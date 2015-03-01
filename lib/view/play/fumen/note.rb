
# encoding: utf-8

# 显示单个音符的精灵。

module View
  class Play
    class Fumen
      class Note < Sprite

        include Taiko

        # 初始化
        def initialize(_)
          super
          self.note = nil
        end

        # 更新
        def update
          return unless @note
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