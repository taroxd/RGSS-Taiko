# encoding: utf-8

require 'view/view_container'
require 'view/animation'

module View
  class Play
    class NoteFly < ViewContainer
      def initialize(viewport)
        super(Note, viewport)
      end

      def update
        yield_view(&:reset_and_show) if to_show?
        super
      end

      private

      def to_show?
        return false unless Taiko.last_hit
        unless @last_hit.equal? Taiko.last_hit
          @last_hit = Taiko.last_hit
          @last_status = nil
        end
        return false if @last_hit.performance == :miss
        return false if @last_hit.balloon?
        return false if @last_status == @last_hit.status
        @last_status = @last_hit.status
        true
      end

      class Note < Animation
        def initialize(viewport)
          super(viewport,
            {
              x: SkinSettings.fetch(:NoteEffectX),
              y: SkinSettings.fetch(:NoteEffectY),
              z: 0,
            },
            {duration: 10}
          )
        end

        # 重置并显示
        def reset_and_show
          self.bitmap = Cache.note_head(Taiko.last_hit.type)
          @frame = 0
          set_frame
          show
          set_change_effect
        end

        # 设置图像变更时的特效
        def set_change_effect
          self.y = @change_effect[1] if @change_effect
          self.x = @change_effect[2] if @change_effect
          @change_effect = [20, self.y, self.x]
        end

        # 更新图像变更时的特效
        def update_change_effect
          if @change_effect[0] > 0
            self.y -= 5
            @change_effect[0] -= 2
          end
        end

        def update
          super
          return unless self.visible
          return unless self.bitmap
          update_change_effect
        end
      end
    end
  end
end