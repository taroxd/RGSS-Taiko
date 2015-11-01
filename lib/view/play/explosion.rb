# encoding: utf-8

require 'view/animation'

module View
  class Play
    class Explosion
      class Base < Animation

        def frame_height
          self.bitmap.height / 4
        end

        def reset_and_show(type)
          @duration = 0
          @frame_y = self.bitmap.height / 4 * type
          reset
        end
      end

      def initialize(viewport_upper, viewport_lower)
        @upper = Base.new(viewport_upper,
          x: EXPLOSION_UPPER_X, y: EXPLOSION_UPPER_Y, z: 0,
          frame: EXPLOSION_UPPER_FRAME, duration: 1, bitmap: 'explosion_upper')

        @lower = Base.new(viewport_lower,
          x: EXPLOSION_LOWER_X, y: EXPLOSION_LOWER_Y, z: 100,
          frame: EXPLOSION_LOWER_FRAME, duration: 1, bitmap: 'explosion_lower')

        Taiko.hit_callback do |note|
          next if note.performance == :miss || !note.normal?
          type = note.performance == :perfect ? 0 : 1
          type += note.double ? 2 : 0
          @upper.reset_and_show(type)
          @lower.reset_and_show(type)
        end
      end

      def update
        @upper.update
        @lower.update
      end

      def dispose
        @upper.dispose
        @lower.dispose
      end
    end
  end
end