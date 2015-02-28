# encoding: utf-8
require 'taiko/note/roll_base'

module Taiko
  module Note
    class Balloon < RollBase
      # 气球音符
      def balloon?
        true
      end

      # 设置气球的连打数
      def number=(number)
        @status = number
      end

      # X 坐标
      def x
        return 0 if hitting?
        return (end_time - play_time) * @speed if over?
        super
      end

      # 位图宽度
      def width
        NOTE_SIZE * 2
      end

      # 是否正在击打
      def hitting?
        @status && super
      end

      # 击打
      def hit
        @status -= 1
        if @status <= 0
          @status = false
          Audio.se_play 'Audio/SE/balloon', se_vol
        end
      end

      # 分数
      def score
        score = @status ? 300 : 5000
        score = score * 6 / 5 if gogotime?
        score
      end

      # 绘制
      def draw(bitmap)
        bitmap.blt 0, 0, Cache.notes, Rect.new(600, 0, width, NOTE_SIZE)
      end
    end
  end
end