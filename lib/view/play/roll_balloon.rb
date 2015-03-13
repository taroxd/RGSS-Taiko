
require 'view/number'

module View
  class Play
    class RollBalloon

      class RollNumber < Number
        def pos_x; ROLL_BALLOON_X + 64; end
        def pos_y; ROLL_BALLOON_Y + 20; end
        def pos_width; ROLL_BALLOON_WIDTH; end
        def get_bitmap; Cache.skin('combonumber'); end
        def pos_z; 0; end
        def pos_type; 2; end
      end

      def initialize(viewport)
        @back = Sprite.new(viewport)
        @back.bitmap = Cache.skin('rollballoon')

        @back.x = ROLL_BALLOON_X
        @back.y = ROLL_BALLOON_Y

        @number = RollNumber.new(viewport)

        Taiko.hit_callback(method(:set_note))

        hide
      end

      def update
      end

      def dispose
        @back.dispose
        @number.dispose
      end

      private

      def set_note(note)
        note.roll? ? show(note.number) : hide
      end

      def hide
        @back.visible = false
        @number.clear
      end

      def show(number)
        @back.visible = true
        @number.show(number)
      end
    end
  end
end