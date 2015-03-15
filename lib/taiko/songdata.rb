# encoding: utf-8

# 管理谱面文件的读取以及谱面信息的类。

module Taiko
  class Songdata

    HEADER_RE = /#?(\w+) *:?(.*)/      # 头部设定
    DIRECTIVE_RE = /^# *(\w+) *:?(.*)/ # 谱面中指令
    COMMENT_RE = /\/\/.+/              # 注释

    TJAError = Class.new(StandardError)

    attr_reader(
      # 不包含扩展名的文件路径
      :name,

      # TJA 文件头部指定的信息
      :title, :subtitle, :wave, :balloons, :scoreinit,
      :scorediff, :songvol, :sevol, :level, :course,

      # gogotimes 的范围（Range）构成的数组
      :gogotimes,

      # 前一难度的 songdata。若不存在，返回伪值。
      :prev_course
    )

    # name: 文件名（不包含后缀）
    def initialize(name)
      @name = name
      init_data
      read_header
    end

    # 谱面，一个哈希表。
    # 键为 type（取值见 Taiko 的常量），
    # 值为一个哈希表，其中键为音符的速度，值为对应该速度的音符时机构成的数组。
    def fumen
      parse_fumen unless @fumen
      @fumen
    end

    # 返回下一难度的 songdata。若不存在，返回伪值。
    def next_course
      return @next_course unless @next_course.nil?
      read_fumen_string   # 如果只读取了 header，先读取所有谱面的内容
      @next_course = dup
      @next_course.read_next_course
      @next_course.prev_course = self
      @next_course
    rescue EOFError
      @next_course = false
    end

    protected

    attr_writer :prev_course

    # 读取下一难度
    def read_next_course
      @fumen = @fumen_string = nil
      read_header
    end

    private

    # 初始化数据
    def init_data
      @wave = @name
      @bpm = 120.0
      @time = 0.0
      @measure = [4, 4]
      @scoreinit = 100
      @scorediff = 20
      @scroll = 1.0
      @sevol = @songvol = 100
      @barline_on = true
      @balloons = []
      @gogotimes = []
      @file = File.open("#{@name}#{EXTNAME}")
    end

    # 读取歌曲头部信息
    def read_header
      read_until("\n#START").each_line do |line|
        if line =~ HEADER_RE
          sym = :"header_#{$1.downcase}"
          if respond_to?(sym, true)
            @contents = $2
            send(sym)
          end
        end
      end
    end

    # 读取谱面的内容
    def fumen_string
      return @fumen_string if @fumen_string
      @fumen_string = read_until("\n#END")
    end

    alias_method :read_fumen_string, :fumen_string

    # 读取谱面信息。在读取头部信息之后调用
    def parse_fumen
      @fumen = Array.new(8) { Hash.new { |h, k| h[k] = [] } }

      fumen_string.each_line(',') do |bar|
        lines = bar.each_line.map(&:strip)

        # 读取小节间的指令
        while (@line = lines.first)
          @line.empty? || read_directive ? lines.shift : break
        end

        # 添加小节线
        add_note(BARLINE) if @barline_on

        # 计算小节内的音符总数
        count = lines.inject(0) do |a, line|
          line =~ DIRECTIVE_RE ? a : a + line.count('0-9')
        end

        # 读取小节内容
        if count == 0
          @time += bar_length
        else
          @interval = bar_length / count
          lines.each do |line|
            @line = line
            read_directive || read_notes
          end
          @interval = nil
        end
      end

      set_gogoend
      check_validity
    end

    # 小节长度
    def bar_length
      240000.0 / @bpm * @measure[0] / @measure[1]
    end

    # 读取指令。读取失败时返回伪值。
    def read_directive
      if @line =~ DIRECTIVE_RE
        sym = :"directive_#{$1.downcase}"
        if respond_to? sym, true
          @contents = $2
          send sym
        end
        true
      end
    end

    # 读取音符
    def read_notes
      @line.each_char do |char|
        next unless char.between?('0', '9')
        type = char.to_i
        case type
        when 1, 2, 3, 4 then add_note(type, false)
        when 5, 6, 7 then add_note(type, true)
        when 8 then end_roll
        when 9 then add_note(5, true) # 9 is currently not supported
        end
        @time += @interval
      end
    end

    def self.define_header(name, conversion = nil)
      class_eval <<-EOF, __FILE__, __LINE__
        def header_#{name}
          @#{name} = #{conversion}(@contents)
        #{if conversion
            "rescue ArgumentError
               @#{name}"
          end
        }
        rescue ArgumentError
          @#{name}
        end
      EOF
    end

    # def header_scoreinit
    #   @scoreinit = Integer(@contents)
    # rescue ArgumentError
    #   @scoreinit
    # end
    define_header :scoreinit, 'Integer'
    define_header :scorediff, 'Integer'
    define_header :songvol,   'Integer'
    define_header :sevol,     'Integer'
    define_header :level,     'Integer'

    define_header :title
    define_header :subtitle
    define_header :course

    # 获取 bpm
    def header_bpm
      invalid_in_a_bar('BPMCHANGE')
      begin
        @bpm = Float(@contents)
      rescue ArgumentError
        @bpm
      else
        update_speed
      end
    end

    # 获取音乐文件名
    def header_wave
      @wave = File.dirname(@name) + '/' + @contents
    end

    # 获取拍号
    def header_measure
      invalid_in_a_bar('MEASURE')
      if @contents =~ /(\d+)(?:\s+|\s*\/\s*)(\d+)/i
        @measure = [$1.to_i, $2.to_i]
      end
    end

    # 获取延迟
    def header_offset
      @time = -1000.0 * Float(@contents)
    rescue ArgumentError
      @time
    end

    # 获取谱面滚动速度
    def header_scroll
      @scroll = Float(@contents)
    rescue ArgumentError
      @scroll
    else
      update_speed
    end

    # 获取气球数量
    def header_balloon
      sep = @contents.include?(',') ? ',' : ' '
      @balloons = @contents.split(sep).map(&:to_i)
    end

    # 跳过双人谱面
    def header_style
      if @contents.downcase.include?('double')
        2.times { read_until("\n#END") }
        read_header
      end
    end

    # 指令集
    alias_method :directive_bpm, :header_bpm
    alias_method :directive_bpmchange, :header_bpm
    alias_method :directive_measure, :header_measure
    alias_method :directive_scroll, :header_scroll

    # GGT 开始
    def directive_gogostart
      set_gogostart || tjaerror('unexpected #GOGOSTART')
    end

    # GGT 结束
    def directive_gogoend
      set_gogoend || tjaerror('unexpected #GOGOEND')
    end

    # 打开小节线
    def directive_barlineon
      @barline_on = true
    end

    # 关闭小节线
    def directive_barlineoff
      @barline_on = false
    end

    # 延迟
    def directive_delay
      @time += Float(@contents) * 1000.0
    rescue ArgumentError
      @time
    end

    # 确认当前并没有在读取音符
    def invalid_in_a_bar(directive)
      tjaerror "unexpected ##{directive} inside a bar" if @interval
    end

    # 更新音符速度
    def update_speed
      @speed = @bpm * @scroll / 500.0
    end

    # 当前是否进入了 gogotime 状态
    def in_gogotime?
      @gogotimes.last.kind_of?(Numeric)
    end

    # 设置 gogotime 的起点。设置失败时返回伪值。
    def set_gogostart
      @gogotimes.push(@time.to_i) unless in_gogotime?
    end

    # 设置 gogotime 的终点。设置失败时返回伪值。
    def set_gogoend
      @gogotimes[-1] = @gogotimes[-1]..@time.to_i if in_gogotime?
    end

    # 向谱面中添加一个音符
    def add_note(type, is_roll = false)
      if @last_roll
        if type != BARLINE && type != @last_roll
          tjaerror "unexpected note (#{type}), expecting roll end (8)"
        end
      else
        @fumen[type][@speed].push(@time.to_i)
        @last_roll = type if is_roll
      end
    end

    # 结束连打音符
    def end_roll
      if @last_roll
        notes = @fumen[@last_roll][@speed]
        notes[-1] = notes[-1]..@time.to_i
        @last_roll = nil
      else
        tjaerror 'unexpected roll end (8)'
      end
    end

    # 检查谱面
    def check_validity
      check_balloon
      check_roll_end
    end

    # 检查气球个数
    def check_balloon
      balloons_size = @fumen[BALLOON].values.inject(0) { |a, e| a + e.size }
      if @balloons.size < balloons_size
        tjaerror "wrong number of balloons (#{@balloons.size} for #{balloons_size})"
      end
    end

    # 检查连打是否正常结束
    def check_roll_end
      tjaerror 'unexpected #END, expecting roll end (8)' if @last_roll
    end

    # 抛出异常
    def tjaerror(message)
      raise TJAError, message
    end

    # 读取文件并清除注释。到文件尾时抛出 EOFError。
    def read_until(sep)
      ret = @file.readline(sep)
      unless ret.end_with?(sep)
        @file.close
        raise EOFError
      end
      ret.gsub(COMMENT_RE, '')
    end
  end
end
