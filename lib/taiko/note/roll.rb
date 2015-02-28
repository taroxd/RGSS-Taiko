# encoding: utf-8
require 'taiko/note/roll_base'

module Taiko
  module Note
    class Roll < RollBase
      # 黄条音符
      def roll?
        true
      end

      # 是否是大黄条
      def big?
        @type == ROLL_BIG
      end

      # 分数
      def score
        score = big? ? 360 : 300
        score = score * 6 / 5 if gogotime?
        score
      end

      # 位图的宽度
      def width
        super + body_width
      end

      # 黄条体的宽度
      def body_width
        ((@time.end - @time.begin) * @speed).to_i
      end

      # 击打
      def hit
        @status += 1
      end

      # 绘制
      def draw(bitmap)
        src = Cache.notes
        dest = Rect.new(ox, 0, body_width, NOTE_SIZE)
        rect = Rect.new(big? ? 480 : 300, 0, NOTE_SIZE, NOTE_SIZE)
        bitmap.stretch_blt(dest, src, rect)
        rect.x += NOTE_SIZE * 3 / 2
        rect.width = NOTE_SIZE / 2
        bitmap.blt(ox + body_width, 0, src, rect)
        rect.x = big? ? 780 : 720
        rect.width = NOTE_SIZE
        bitmap.blt(0, 0, src, rect)
      end
    end
  end
end