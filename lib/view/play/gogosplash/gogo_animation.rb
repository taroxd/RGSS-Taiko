# encoding: utf-8

require 'view/animation'

module View
  class Play
    class Gogosplash
      class GogoAnimation < Animation
        # 精灵的位图由调用者提供
        def get_bitmap(bitmap)
          bitmap
        end
      end
    end
  end
end