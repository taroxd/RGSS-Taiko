# encoding: utf-8

require 'view/number'

#   显示分数的精灵组
module View
  class Score

    class Add < Number
      def update
        if @change_effect && @change_effect > 0
          digits.each { |s| s.x += 2 }
          @change_effect -= 1
        end
      end

      private

      def on_change
        @change_effect = 5
        digits.each { |s| s.x -= 10 }
      end
    end

    def initialize(viewport)
      @sprite_score = Number.new(viewport, x: SCORE_X, y: SCORE_Y, alignment: 2, bitmap: 'font_m')
      @sprite_add   = Add.new(viewport, x: SCORE_X2, y: SCORE_Y2, alignment: 2, bitmap: 'font_m_red')
      @score = 0
      @clear_time = 0
    end

    def update
      @clear_time -= 1
      if @score != Taiko.score
        score_last = @score
        @score = Taiko.score
        @sprite_score.show(@score)
        @sprite_add.show(@score - score_last)
        @clear_time = 40
      else
        @sprite_add.clear if @clear_time < 0
      end
      @sprite_add.update
    end

    def dispose
      @sprite_score.dispose
      @sprite_add.dispose
    end
  end
end