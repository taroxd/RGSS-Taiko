
require 'view/number'

module View
  class Play
    class RollBalloon

      def initialize(viewport)
        @back = Sprite.new(viewport)
        @back.bitmap = Cache.skin('rollballoon')

        @back.x = ROLL_BALLOON_X
        @back.y = ROLL_BALLOON_Y

        @number = Number.new(viewport, x: ROLL_BALLOON_X + 64, y: ROLL_BALLOON_Y + 20,
          interval: ROLL_BALLOON_INTERVAL, bitmap: 'combonumber', alignment: 2)

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