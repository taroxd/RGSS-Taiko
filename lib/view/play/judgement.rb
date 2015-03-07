# encoding: utf-8
# 显示打击准确度和音符飞起的效果

require 'view/view_container'
require 'view/play/judgement/judge'
require 'view/play/judgement/note_effect'

module View
  class Play
    class Judgement

      def initialize(viewport)
        @note_effects = ViewContainer.new(NoteEffect, viewport)
        @judge = Judge.new(viewport)
      end

      def update
        return unless Taiko.last_hit
        if @last_hit != Taiko.last_hit
          @last_hit = Taiko.last_hit
          @last_hit_status = nil
          reset_judge if @last_hit.normal?
        end

        @note_effects.yield_view { |v| v.reset_and_show(@last_hit) } if note_effect_show?
        @judge.update
        @note_effects.update
      end

      def dispose
        @note_effects.dispose
        @judge.dispose
      end

      private

      def reset_judge
        type = case @last_hit.performance
        when :miss  then 2
        when :great then 1
        else             0
        end
        @judge.reset_and_show(type)
      end

      def note_effect_show?
        return false if @last_hit.performance == :miss
        return false if @last_hit.balloon?
        return false if @last_hit_status == @last_hit.status
        @last_hit_status = @last_hit.status
        true
      end
    end
  end
end