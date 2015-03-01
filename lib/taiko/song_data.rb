#encoding:utf-8

#  管理谱面文件的读取以及谱面信息的类。

module Taiko
  class SongData
    HEADER_RE = /#?(\w+) *:?(.*)/      # 头部设定
    DIRECTIVE_RE = /^# *(\w+) *:?(.*)/ # 谱面中指令
    COMMENT_RE = /\/\/.+/              # 注释
    attr_reader(

      # 谱面，一个哈希表。
      # 键为 type（取值见 Taiko 的常量），
      # 值为一个哈希表，其中键为音符的速度，值为对应该速度的音符时机构成的数组。
      :fumen,

      # 不包含扩展名的文件路径
      :name,

      # TJA 文件头部指定的信息
      :title, :subtitle, :wave, :balloons, :score_init,
      :score_diff, :song_vol, :se_vol, :level,

      # gogotimes 的范围（Range）构成的数组
      :gogotimes
    )

    # 读取头部信息
    def self.header(name)
      new.tap { |data| data.header = name }
    end

    # 初始化
    def initialize(name = nil)
      self.name = name if name
    end

    # 设置文件名并读取文件
    def name=(name)
      @name = name
      init_data
      load_songdata
      check_validity
    end

    # 设置文件名并读取头部信息
    def header=(name)
      @name = name
      init_data
      load_header
    end

    private

    # 初始化数据
    def init_data
      @fumen = Array.new(8) { Hash.new { |h, k| h[k] = [] } }
      @wave = @name
      @bpm = 120.0
      @time = 0.0
      @measure = [4, 4]
      @score_init = 100
      @score_diff = 20
      @scroll = 1.0
      @se_vol = @song_vol = 100
      @barline_on = true
      @balloons = []
      @gogotimes = []
    end

    # 读取数据
    def load_songdata
      File.open("#@name#{EXTNAME}") do |f|
        @string = f.gets('#START')
        read_header
        @string = f.gets('#END')
      end
      read_contents
    end

    # 读取头部数据
    def load_header
      File.open("#@name#{EXTNAME}") { |f| @string = f.gets('#START') }
      read_header
    end

    # 读取歌曲基本信息
    def read_header
      @string.gsub!(COMMENT_RE, '')
      @string.each_line do |line|
        if line =~ HEADER_RE
          sym = :"header_#{$1.downcase}"
          if respond_to? sym, true
            @contents = $2
            send sym
          end
        end
      end
    end

    # 读取谱面信息
    def read_contents
      @string.gsub!(COMMENT_RE, '')
      @string.each_line(',') do |bar|
        lines = bar.each_line.map(&:strip)
        while @line = lines.first
          @line.empty? || read_directive ? lines.shift : break
        end
        @fumen[0][@speed].push(@time.to_i) if @barline_on
        count = lines.inject(0) do |a, line|
          line =~ DIRECTIVE_RE ? a : a + line.count('0-9')
        end
        if count == 0
          @time += bar_length
        else
          @interval = bar_length / count
          lines.each do |line|
            @line = line
            read_directive || read_fumen
          end
          @interval = nil
        end
      end
    end

    # 小节长度
    def bar_length
      240000.0 / @bpm * @measure[0] / @measure[1]
    end

    # 读取指令
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

    # 读取谱面
    def read_fumen
      @line.each_char do |char|
        case char
        when '0'
          @time += @interval
        when '1', '2', '3', '4'
          check_roll
          @fumen[char.to_i][@speed].push(@time.to_i)
          @time += @interval
        when '5', '6', '7'
          roll = char.to_i
          unless @last_roll == roll
            check_roll
            @last_roll = roll
            @fumen[roll][@speed].push(@time.to_i)
          end
          @time += @interval
        when '8'
          check_roll(true)
          notes = @fumen[@last_roll][@speed]
          notes[-1] = notes[-1]..@time.to_i
          @last_roll = nil
          @time += @interval
        end
      end
    end

    # 获取歌曲名
    def header_title
      @title = @contents
    end

    # 获取副标题
    def header_subtitle
      @subtitle = @contents
    end

    # 获取 bpm
    def header_bpm
      invalid_in_a_bar
      @bpm = @contents.to_f
      update_speed
    end

    # 获取音乐文件名
    def header_wave
      @wave = File.dirname(@name) + '/' + @contents
    end

    # 获取拍号
    def header_measure
      invalid_in_a_bar
      if @contents =~ /(\d+)(?:\s+|\s*\/\s*)(\d+)/i
        @measure = [$1.to_i, $2.to_i]
      end
    end

    # 获取延迟
    def header_offset
      @time = -1000.0 * @contents.to_f
    end

    # 获取初项
    def header_scoreinit
      @score_init = @contents.to_i
    end

    # 获取公差
    def header_scorediff
      @score_diff = @contents.to_i
    end

    # 获取歌曲音量
    def header_songvol
      @song_vol = @contents.to_i
    end

    # 获取音效音量
    def header_sevol
      @se_vol = @contents.to_i
    end

    # 获取谱面滚动速度
    def header_scroll
      @scroll = @contents.to_f
      update_speed
    end

    # 获取星级
    def header_level
      @level = @contents.to_i
    end

    # 获取气球数量
    def header_balloon
      sep = @contents.include?(',') ? ',' : ' '
      @balloons = @contents.split(sep).map(&:to_i)
    end

    # 指令集
    alias_method :directive_bpm, :header_bpm
    alias_method :directive_bpmchange, :header_bpm
    alias_method :directive_measure, :header_measure
    alias_method :directive_scroll, :header_scroll

    # GGT 开始
    def directive_gogostart
      check_gogotime(false)
      @gogotimes.push(@time.to_i)
    end

    # GGT 结束
    def directive_gogoend
      check_gogotime(true)
      @gogotimes[-1] = @gogotimes[-1]..@time.to_i
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
      @time += @contents.to_f * 1000.0
    end

    # 确认当前并没有在读取音符
    def invalid_in_a_bar
      raise SyntaxError, 'unexpected directive' if @interval
    end

    # 更新音符速度
    def update_speed
      @speed = @bpm * @scroll / 500.0
    end

    # 检查是否正在连打
    def check_roll(should_roll = false)
      if should_roll ^ @last_roll
        raise TypeError, 'unexpected roll note or stop rolling'
      end
    end

    # 检查 gogotime
    def check_gogotime(should_num = false)
      if should_num ^ @gogotimes.last.kind_of?(Numeric)
        raise TypeError, 'unexpected GOGOSTART or GOGOEND'
      end
    end

    # 检查谱面
    def check_validity
      check_balloon
      check_roll
      check_gogotime
    end

    # 检查气球个数
    def check_balloon
      balloons_size = @fumen[BALLOON].values.inject(0) { |a, e| a + e.size }
      if @balloons.size != balloons_size
        raise ArgumentError,
          "wrong number of balloons (#{@balloons.size} for #{balloons_size})"
      end
    end
  end
end
