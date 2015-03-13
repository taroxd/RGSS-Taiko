#encoding:utf-8

# 该类管理值槽。
module Taiko
  class Gauge

    NORMAL_RATE = 0.8  # 及格线

    def initialize
      @value = 0
      @max = (Taiko.fumen.dons.size + Taiko.fumen.kas.size) * 5
    end

    # 添加音符 -> self
    def <<(performance)
      @value += case performance
      when :perfect then 6
      when :great   then 3
      when :miss    then -12
      end
      @value = 0    if @value < 0
      @value = @max if @value > @max
      self
    end

    # 是否及格
    def normal?
      @max * NORMAL_RATE >= @value
    end

    # 是否满魂
    def soul?
      @value == @max
    end

    # 当前值占满值的比例
    def rate
      @value.fdiv(@max)
    end
  end
end