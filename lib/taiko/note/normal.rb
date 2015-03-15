# encoding: utf-8
require 'taiko/note/base'

module Taiko
  module Note
    class Normal < Base
      # 是否两边一起按下
      attr_accessor :double

      # 普通音符
      def normal?
        true
      end

      # 击打时音符消失
      def hit
        @status = false unless over?
      end

      # 是否是大音符
      def big?
        @type == DON_BIG || @type == KA_BIG
      end

      # 是否在 gogotime 中
      def gogotime?
        Taiko.songdata.gogotimes.any? { |range| range.include?(@time) }
      end

      # 分数
      def score
        return 0 if !@performance || @performance == :miss
        score = Taiko.scoreinit + [Taiko.combo / 10, 10].min * Taiko.scorediff
        score *= 2 if big? && @double
        score /= 2 if performance == :great
        score = score * 6 / 5 if gogotime?
        score
      end

      # 获取判定
      def performance
        @performance ||= judge
      end

      # 判定
      def judge
        offset = (Taiko.play_time - @time).abs
        return :perfect if offset < PERFECT_JUDGE
        return :great   if offset < GREAT_JUDGE
        return :miss    if offset < MISS_JUDGE || over?
        nil
      end

      # 是否已经过了击打时间
      def over?
        Taiko.play_time - @time > MISS_JUDGE
      end

      # 绘制位图
      def draw(bitmap)
        rect = Rect.new (@type - 1) * NOTE_SIZE, 0, NOTE_SIZE, NOTE_SIZE
        bitmap.blt(0, 0, Cache.notes, rect)
      end
    end
  end
end