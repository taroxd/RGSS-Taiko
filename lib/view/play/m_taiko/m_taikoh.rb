# encoding: utf-8

#  显示玩家按键的精灵。

require 'view/animation'

module View
  class MTaikoh < Animation
    # 精灵的位图由调用者提供
    def get_bitmap(bitmap)
      bitmap
    end

    def show
      @frame = 0
      set_frame
      super
    end
  end
end