#encoding:utf-8

# 显示当前连击数

require 'view/play/combo/combo_number'
require 'view/play/combo/combo_number_l'
require 'view/play/combo/flower'

module View
  class Play
    class Combo
      #--------------------------------------------------------------------------
      # ● 初始化
      #--------------------------------------------------------------------------
      def initialize(viewport = nil)
        @combo1 = ComboNumber.new(viewport)
        @combo2 = ComboNumberL.new(viewport)
        @flower = Flower.new(viewport,
          {x: pos_x, y: pos_y, z: pos_z},{duration: duration_time})
        @combo_number = 0
        Taiko.hit_callback { update_combo }
        hide
      end
      #--------------------------------------------------------------------------
      # ● 花朵X坐标
      #--------------------------------------------------------------------------
      def pos_x; SkinSettings.fetch(:MtaikoflowerX); end
      #--------------------------------------------------------------------------
      # ● 花朵Y坐标
      #--------------------------------------------------------------------------
      def pos_y; SkinSettings.fetch(:MtaikoflowerY); end
      #--------------------------------------------------------------------------
      # ● 花朵Z坐标
      #--------------------------------------------------------------------------
      def pos_z; -1; end
      #--------------------------------------------------------------------------
      # ● 花朵显示时间
      #--------------------------------------------------------------------------
      def duration_time; 60; end
      #--------------------------------------------------------------------------
      # ● 更新
      #--------------------------------------------------------------------------
      def update
        @flower.update
      end

      def update_combo
        combo = Taiko.combo
        if combo < 10
          hide
        else
          @flower.show if combo % 50 == 0
          if combo < 50
            @combo1.show(combo)
          else
            @combo1.clear
            @combo2.show(combo)
          end
        end
      end
      #--------------------------------------------------------------------------
      # ● 隐藏
      #--------------------------------------------------------------------------
      def hide
        @combo1.clear
        @combo2.clear
        @flower.hide
      end
      #--------------------------------------------------------------------------
      # ● 释放
      #--------------------------------------------------------------------------
      def dispose
        @combo1.dispose
        @combo2.dispose
        @flower.dispose
      end
    end
  end
end