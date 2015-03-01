# encoding: utf-8

# 显示谱面（所有音符）的精灵组

require 'view/play/fumen/note'

module View
  class Play
    class Fumen

      def initialize(viewport)
        @viewport = viewport
        @notes = Taiko.fumen.notes_for_display
        create_sprites
      end

      def update
        push_notes
        shift while @size > 0 && !@sprites.first.valid?
        @size.times { |i| @sprites[i].update }
      end

      def dispose
        @sprites.each(&:dispose)
      end

      private

      def create_sprites
        @sprites = []
        @size = 0
        push_notes
      end

      # 加入要显示的所有音符
      def push_notes
        loop do
          note = @notes.first
          break if !note || note.appear_time > Taiko.play_time
          push(note)
          @notes.shift
        end
      end

      # 添加音符
      def push(note)
        sprite = @sprites[@size] ||= Note.new(@viewport)
        sprite.note = note
        @size += 1
      end

      # 删除音符
      def shift
        @sprites.first.note = nil
        @sprites.rotate!
        @size -= 1
      end
    end
  end
end