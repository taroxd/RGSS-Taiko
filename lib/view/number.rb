# encoding: utf-8

require 'view/digit'

module View
  Number = Struct.new(:x, :y, :z, :interval, :alignment) do

    # interval
    #   数字间的间距
    #
    # alignment
    #   0: 居左 1: 居中 2: 居右

    # Number.new(viewport, x: 233, bitmap: 'combonumber')
    def initialize(viewport, options = {})
      parse_options(options)
      @digits = []
      @viewport = viewport
      # show(0)
    end

    def clear
      @num_now = nil
      @digits.each(&:clear)
    end

    # virtual
    def update
    end

    def dispose
      @digits.each(&:dispose)
    end

    def show(num)
      return if num == @num_now
      @num_now = num
      clear
      digit_width = bitmap.width / 10 + interval
      num_s = num.to_s
      num_s.each_char.with_index do |char, index|
        digit = @digits[index] ||= Digit.new(@viewport, bitmap)
        digit.x = x + digit_width * index
        digit.y = y
        digit.z = z
        digit.show(char.to_i)
      end
      update_placements(digit_width * num_s.length - interval)
      on_change
    end

    # 计算显示位置
    def update_placements(total_width)
      return if alignment.zero?
      @digits.each do |digit|
        digit.x -= case alignment
        when 1 then total_width / 2
        when 2 then total_width
        end
      end
    end

    # virtual
    # 容纳十个数字的位图
    def bitmap
      @bitmap || raise(TypeError, 'bitmap not given')
    end

    private

    # 返回 Digit 的数组
    attr_reader :digits

    def parse_options(options)
      members.each do |sym|
        self[sym] = options.fetch(sym, 0)
      end

      @bitmap = Cache.try_convert(options[:bitmap])
    end

    # virtual
    # 重设数字时的处理
    def on_change
    end
  end
end