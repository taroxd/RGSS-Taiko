#encoding:utf-8

require 'scene/base'
require 'spriteset/spriteset_play'

#  演奏场景
module Scene
  class Play < Base
    include Taiko
    private

    # 开始
    def start
      super
      @spriteset = Spriteset_Play.new
    end

    # 更新
    def update
      super
      started? ? update_after_started : update_before_started
      update_sound_effect
      @spriteset.update
      update_scene unless scene_changing?
    end

    # 终止
    def terminate
      super
      @spriteset.dispose
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
      update_pending_note
      update_inner if Keyboard.inner?
      update_outer if Keyboard.outer?
    end

    # 更新已经击打过一遍的大音符
    def update_pending_note
      return unless @pending_note
      return unless (@pending_note[2] -= 1) == 0
      notes, note = @pending_note
      if note.valid?
        Taiko.hit(note)
        notes.shift
      end
      @pending_note = nil
    end

    # 更新鼓面的击打
    def update_inner
      find_rolls_and_hit(fumen.rolls)    ||
      find_rolls_and_hit(fumen.balloons) ||
      find_note_and_hit(fumen.dons, Keyboard.both_inner?)
    end

    # 更新鼓边的击打
    def update_outer
      find_rolls_and_hit(fumen.rolls) ||
      find_note_and_hit(fumen.kas, Keyboard.both_outer?)
    end

    # 搜索音符并击打
    # double: 这一瞬间是否两键同时按下
    def find_note_and_hit(notes, double)
      note = notes.first
      return if !note || !note.performance
      note.double = double
      if note.big? && !double
        @pending_note = notes, note, 2
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
      shift_missed_notes(fumen.dons,     true)
      shift_missed_notes(fumen.kas,      true)
      shift_missed_notes(fumen.rolls,    false)
      shift_missed_notes(fumen.balloons, false)
    end

    # 移除丢失的音符
    def shift_missed_notes(notes, hit)
      note = notes.first
      return unless note
      while note && note.over?
        notes.shift
        Taiko.hit(note) if hit
        note = notes.first
      end
    end

    # 更新音效
    def update_sound_effect
      Audio.se_play 'Audio/SE/dong', se_vol if Keyboard.inner?
      Audio.se_play 'Audio/SE/ka',   se_vol if Keyboard.outer?
    end

    # 切换场景
    def update_scene
      if Input.trigger?(:B)
        Taiko.stop
        fadeout_all(120)
        return_scene
      end
    end
  end
end
