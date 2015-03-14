#encoding:utf-8

# 显示当前连击数

module View
  class Play
    class Combo

      class Flower < Animation

        def get_bitmap(_)
          Cache.skin("mtaikoflower")
        end

        def show
          @frame = 0
          set_frame
          super
        end
      end

      def initialize(viewport)
        @combo_number = 0

        @combo1 = Number.new(viewport,
          x: COMBO_NUMBER_X, y: COMBO_NUMBER_Y, interval: COMBO_NUMBER_INTERVAL,
          alignment: 1, bitmap: 'combonumber')

        @combo2 = Number.new(viewport,
          x: COMBO_NUMBER_X2, y: COMBO_NUMBER_Y2, interval: COMBO_NUMBER_INTERVAL2,
          alignment: 1, bitmap: 'combonumber_l')

        @flower = Flower.new(viewport,
          {x: MTAIKOFLOWER_X, y: MTAIKOFLOWER_Y, z: -1},
          {duration: MTAIKOFLOWER_DURATION}
        )

        Taiko.hit_callback { update_combo }
        hide
      end

      def update
        @flower.update if @flower.visible
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

      def hide
        @combo1.clear
        @combo2.clear
        @flower.hide
      end

      def dispose
        @combo1.dispose
        @combo2.dispose
        @flower.dispose
      end
    end
  end
end