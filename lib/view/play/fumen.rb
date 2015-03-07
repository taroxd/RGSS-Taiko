# encoding: utf-8

# 显示谱面（所有音符）的精灵组

require 'view/view_container'

module View
  class Play
    class Fumen < ViewContainer
      def initialize(viewport)
        @notes = Taiko.fumen.notes_for_display
        super(Note, viewport)
        push_notes
      end

      def update
        push_notes
        super
      end

      private

      # 加入要显示的所有音符
      def push_notes
        loop do
          note = @notes.first
          break if !note || note.appear_time > Taiko.play_time
          yield_view { |e| e.note = note }
          @notes.shift
        end
      end

      class Note < Sprite

        # 初始化
        def initialize(_)
          super
          self.note = nil
        end

        # 更新
        def update
          return unless @note
          self.visible = valid?
          self.x = @note.x
          self.z = @note.z
        end

        # 精灵是否有效
        def valid?
          @note && @note.valid? && in_screen?
        end

        # 设置音符
        def note=(note)
          @note = note
          if note
            update_bitmap
            self.ox = note.ox
            update
            self.visible = true
          else
            self.visible = false
          end
        end

        private

        # 更新位图
        def update_bitmap
          self.bitmap = Cache.note(@note)
        end

        # 是否在屏幕中
        def in_screen?
          x + width - ox - viewport.ox > 0
        end
      end
    end
  end
end