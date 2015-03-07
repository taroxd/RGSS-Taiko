
require 'view/animation'

module View
  class Play
    class Judgement
      class NoteEffect < Animation
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
        #--------------------------------------------------------------------------
        # ● 重置并显示
        #--------------------------------------------------------------------------
        def reset_and_show(note)
          self.bitmap = Cache.note_head(note.type)
          @frame = 0
          set_frame
          show
          set_change_effect
        end
        #--------------------------------------------------------------------------
        # ● 设置图像变更时的特效
        #--------------------------------------------------------------------------
        def set_change_effect
          self.y = @change_effect[1] if @change_effect
          self.x = @change_effect[2] if @change_effect
          @change_effect = [20, self.y, self.x]
        end
        #--------------------------------------------------------------------------
        # ● 更新图像变更时的特效
        #--------------------------------------------------------------------------
        def update_change_effect
          if @change_effect[0] > 0
            self.y -= 5
            @change_effect[0] -= 2
          end
        end
        #--------------------------------------------------------------------------
        # ● 更新
        #--------------------------------------------------------------------------
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