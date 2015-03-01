# encoding: utf-8

require 'view/score/base'
require 'view/score/add'

#   显示分数的精灵组
module View
  class Score
    #--------------------------------------------------------------------------
    # ● 初始化
    #--------------------------------------------------------------------------
    def initialize(viewport)
      @sprite_score = Base.new(viewport)
      @sprite_add   = Add.new(viewport)
      @sprite_add.clear
      @score = 0
      @clear_time = 0
    end
    #--------------------------------------------------------------------------
    # ● 更新
    #--------------------------------------------------------------------------
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
    #--------------------------------------------------------------------------
    # ● 释放
    #--------------------------------------------------------------------------
    def dispose
      @sprite_score.dispose
      @sprite_add.dispose
    end
  end
end