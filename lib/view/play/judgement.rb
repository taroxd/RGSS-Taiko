#--------------------------------------------------------------------------
# ● Spriteset_Judgement
#
#   显示打击准确度的精灵
#--------------------------------------------------------------------------

require 'view/play/judgement/judge'
require 'view/play/judgement/note_effect'

module View
  class Play
    class Judgement
      #--------------------------------------------------------------------------
      # ● 初始化
      #--------------------------------------------------------------------------
      def initialize(viewport = nil)
        @note = NoteEffect.new(viewport,
          {x: note_pos_x, y: note_pos_y, z: note_pos_z},
          {duration: note_duration_time})
        @judge = Judge.new(viewport,
          {x: judge_pos_x, y: judge_pos_y, z: judge_pos_z},
          {duration: judge_duration_time})
      end
      #--------------------------------------------------------------------------
      # ● 弹起音符X坐标
      #--------------------------------------------------------------------------
      def note_pos_x; SkinSettings.fetch(:NoteEffectX); end
      #--------------------------------------------------------------------------
      # ● 弹起音符Y坐标
      #--------------------------------------------------------------------------
      def note_pos_y; SkinSettings.fetch(:NoteEffectY); end
      #--------------------------------------------------------------------------
      # ● 弹起音符Z坐标
      #--------------------------------------------------------------------------
      def note_pos_z; 0; end
      #--------------------------------------------------------------------------
      # ● 弹起音符持续时间
      #--------------------------------------------------------------------------
      def note_duration_time; 10; end
      #--------------------------------------------------------------------------
      # ● 判定X坐标
      #--------------------------------------------------------------------------
      def judge_pos_x; SkinSettings.fetch(:JudgementX); end
      #--------------------------------------------------------------------------
      # ● 判定Y坐标
      #--------------------------------------------------------------------------
      def judge_pos_y; SkinSettings.fetch(:JudgementY); end
      #--------------------------------------------------------------------------
      # ● 判定Z坐标
      #--------------------------------------------------------------------------
      def judge_pos_z; 100; end
      #--------------------------------------------------------------------------
      # ● 判定持续时间
      #--------------------------------------------------------------------------
      def judge_duration_time; 30; end
      #--------------------------------------------------------------------------
      # ● 更新
      #--------------------------------------------------------------------------
      def update
        @judge.update
        @note.update
        return unless Taiko.last_hit
        return if @finish == Taiko.last_hit.time
        type = case Taiko.last_hit.performance
               when :miss    then 2
               when :great   then 1
               else               0
               end
        @finish = Taiko.last_hit.time
        @judge.reset_and_show(type) unless Taiko.last_hit.valid?
        @note.reset_and_show(Taiko.last_hit) unless type == 2
      end
      #--------------------------------------------------------------------------
      # ● 释放
      #--------------------------------------------------------------------------
      def dispose
        @judge.dispose
        @note.dispose
      end
    end
  end
end