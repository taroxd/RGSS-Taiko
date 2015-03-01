
require 'view/number'

module View
  class Play
    class Combo
      class ComboNumberL < Number
        #--------------------------------------------------------------------------
        # ● 获取位图
        #--------------------------------------------------------------------------
        def get_bitmap; Cache.skin("combonumber_l"); end
        #--------------------------------------------------------------------------
        # ● 数字 X 坐标
        #--------------------------------------------------------------------------
        def pos_x; Skin_Setting.setting(:ComboNumberX2); end
        #--------------------------------------------------------------------------
        # ● 数字 Y 坐标
        #--------------------------------------------------------------------------
        def pos_y; Skin_Setting.setting(:ComboNumberY2); end
        #--------------------------------------------------------------------------
        # ● 数字间距的调整
        #--------------------------------------------------------------------------
        def pos_width; Skin_Setting.setting(:ComboNumberWidth2); end
        #--------------------------------------------------------------------------
        # ● 数字 Z 高度
        #--------------------------------------------------------------------------
        def pos_z; 0; end
        #--------------------------------------------------------------------------
        # ● 居中对齐
        #--------------------------------------------------------------------------
        def pos_type; 1; end
      end
    end
  end
end