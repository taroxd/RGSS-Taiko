# encoding: utf-8

# 连击达到一定数目时显示花朵

require 'view/animation'

module View
  class Play
    class Combo
      class Flower < Animation
      #--------------------------------------------------------------------------
        # ● 设置精灵的位图
        #--------------------------------------------------------------------------
        def get_bitmap(_); Cache.skin("mtaikoflower"); end
        #--------------------------------------------------------------------------
        # ● 显示精灵
        #--------------------------------------------------------------------------
        def show
          @frame = 0
          set_frame
          super
        end
      end
    end
  end
end