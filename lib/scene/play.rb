# encoding: utf-8

require 'scene/base'
require 'scene/autoload_view'

#  演奏场景
module Scene
  class Play < Base

    include Taiko
    include AutoloadView

    PendingNote = Struct.new(:notes, :note, :frame) do

      def update
        self.frame -= 1
        if frame.zero?
          Taiko.hit(note)
          notes.shift
        end
      end
    end

    private

    def start
      super
      GC.start # 释放文件句柄，并清理内存
    end

    def update
      super
      Taiko.started? ? update_after_started : update_before_started
      update_sound_effect
      update_view
      update_scene unless scene_changing?
    end

    # 更新画面（基础）
    def update_basic
      super
      Keyboard.update
    end

    # 开始游戏前的更新
    def update_before_started
      Taiko.start if Input.trigger?(:C)
    end

    # 开始游戏后的更新
    def update_after_started
      Taiko.update_time
      update_hit
      check_miss
    end

    # 更新音符的击打
    def update_hit
      @pending_note.update if @pending_note
      update_inner if Keyboard.inner?
      update_outer if Keyboard.outer?
    end

    # 更新鼓面的击打
    def update_inner
      find_rolls_and_hit(Taiko.fumen.rolls)    ||
      find_rolls_and_hit(Taiko.fumen.balloons) ||
      find_note_and_hit(Taiko.fumen.dons, Keyboard.both_inner?)
    end

    # 更新鼓边的击打
    def update_outer
      find_rolls_and_hit(Taiko.fumen.rolls) ||
      find_note_and_hit(Taiko.fumen.kas, Keyboard.both_outer?)
    end

    # 搜索音符并击打
    # double: 这一瞬间是否两键同时按下
    def find_note_and_hit(notes, double)
      note = notes.first
      return if !note || !note.performance
      note.double = double
      if @pending_note && @pending_note.note.equal?(note)
        @pending_note = nil
      elsif note.big? && !double
        @pending_note = PendingNote[notes, note, DOUBLE_TOLERANCE]
        return
      end
      Taiko.hit(note)
      notes.shift
    end

    # 搜索连打音符并击打
    def find_rolls_and_hit(notes)
      note = notes.first
      return if !note || !note.hitting?
      Taiko.hit(note)
    end

    # 检查丢失
    def check_miss
      shift_missed_notes(Taiko.fumen.dons,     true)
      shift_missed_notes(Taiko.fumen.kas,      true)
      shift_missed_notes(Taiko.fumen.rolls,    false)
      shift_missed_notes(Taiko.fumen.balloons, false)
    end

    # 移除丢失的音符
    def shift_missed_notes(notes, hit)
      while (note = notes.first) && note.over?
        notes.shift
        Taiko.hit(note) if hit
      end
    end

    # 更新音效
    def update_sound_effect
      Audio.se_play 'Audio/SE/dong', Taiko.sevol if Keyboard.inner?
      Audio.se_play 'Audio/SE/ka',   Taiko.sevol if Keyboard.outer?
    end

    # 切换场景
    def update_scene
      if Input.trigger?(:B)
        Taiko.stop
        fadeout_all(120)
        Scene.goto(SongList)
      end
    end
  end
end
