# encoding: utf-8

# 选曲列表

require 'view/dispose_bitmap'

module View
  class SongList

    class Songs < Sprite

      include DisposeBitmap

      FONT = Font.new('simhei', 14)
      LINE_HEIGHT = 30
      SCORE_HEIGHT = 15

      def initialize(_)
        super
        self.bitmap = Bitmap.new(Graphics.width, Graphics.height)
        bitmap.font = FONT
        refresh
      end

      def update
        refresh unless @songdata.equal?(songdata)
      end

      private

      def songdata(offset = 0)
        Scene.scene.songdata(offset)
      end

      def refresh
        @songdata = songdata
        bitmap.clear
        draw_up
        draw_current
        draw_down
      end

      # 绘制简单的歌曲信息
      def draw_simple_info(songdata, x, y, width = 340, height = LINE_HEIGHT)
        bitmap.draw_text(x, y, width, height, songdata.title)
        bitmap.draw_text(x, y, width, height, "★#{songdata.level}", 2)
      end

      # 绘制上方的歌曲信息
      def draw_up
        (-3).upto(-1) do |i|
          draw_simple_info(songdata(i), 60, 105 + i * LINE_HEIGHT)
        end
      end

      # 绘制下方的歌曲信息
      def draw_down
        1.upto(3) do |i|
          draw_simple_info(songdata(i), 60, 125 + i * LINE_HEIGHT)
        end
      end

      # 绘制选中的歌曲信息
      def draw_current
        draw_simple_info(@songdata, 120, 110, 340)
        draw_playdata Taiko.load(@songdata.name)

      end

      def draw_playdata(playdata)
        crown_type = case
        when !playdata then 0
        when playdata[:miss].zero? then 3
        when playdata[:normal_clear] then 2
        else 1
        end
        bitmap.blt(65, 115, Cache.skin('clearmark'), Rect.new(28 * crown_type, 0, 28, 28))

        return unless playdata
        bitmap.draw_text(0, Graphics.height - 14, Graphics.width, 14, playdata[:score], 2)
      end
    end
  end
end