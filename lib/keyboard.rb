# encoding: utf-8

#  此模块读取键盘的输入。

module Keyboard

  # 常量设置
  LEFT_OUTER  = 'D'.ord
  LEFT_INNER  = 'F'.ord
  RIGHT_INNER = 'J'.ord
  RIGHT_OUTER = 'K'.ord

  class << self

    # 每个键分别按住了多少帧
    STATES = {
      LEFT_OUTER  => 0,
      LEFT_INNER  => 0,
      RIGHT_OUTER => 0,
      RIGHT_INNER => 0,
    }
    API = Win32API.new("user32", "GetAsyncKeyState", ['I'], 'I')

    # 更新输入
    def update
      STATES.each_key do |key|
        STATES[key] = press?(key) ? STATES[key] + 1 : 0
      end
    end

    # 左鼓面是否按下
    def left_inner?
      trigger? LEFT_INNER
    end

    # 左鼓边是否按下
    def left_outer?
      trigger? LEFT_OUTER
    end

    # 右鼓面是否按下
    def right_inner?
      trigger? RIGHT_INNER
    end

    # 右鼓边是否按下
    def right_outer?
      trigger? RIGHT_OUTER
    end

    # 鼓面是否按下
    def inner?
      left_inner? || right_inner?
    end

    # 鼓边是否按下
    def outer?
      left_outer? || right_outer?
    end

    # 是否同时按下两个鼓面
    def both_inner?
      min, max = [STATES[LEFT_INNER], STATES[RIGHT_INNER]].minmax
      min == 1 && max <= Taiko::DOUBLE_TOLERANCE
    end

    # 是否同时按下两个鼓边
    def both_outer?
      min, max = [STATES[LEFT_OUTER], STATES[RIGHT_OUTER]].minmax
      min == 1 && max <= Taiko::DOUBLE_TOLERANCE
    end

    private

    # 按键是否在按下的状态
    def press?(key)
      API.call(key) < 0
    end

    # 按键是否刚被按下
    def trigger?(key)
      STATES[key] == 1
    end
  end
end
