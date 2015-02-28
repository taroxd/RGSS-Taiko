# encoding: utf-8

require 'taiko/note'

# 管理游戏谱面的类。
module Taiko
  class Fumen

    # 返回谱面中一个类型的音符数组。
    attr_reader :notes, :notes_for_display
    attr_reader :dons, :kas, :rolls, :balloons
    attr_reader :end_time

    def initialize
      @fumen = Taiko.songdata.fumen
      init_notes
      init_notes_for_display
      init_note_types
      init_end_time
    end

    private

    # 初始化所有音符
    def init_notes
      @notes = @fumen.each_with_index.map do |hash, type|
        hash.flat_map do |speed, times|
          times.map { |time| Note[type, time, speed] }
        end
      end
    end

    # 初始化显示用的音符
    def init_notes_for_display
      @notes_for_display = @notes.flatten.sort_by(&:appear_time)
    end

    # 初始化各种类的音符
    def init_note_types
      init_dons
      init_kas
      init_rolls
      init_balloons
    end

    # 初始化红色音符
    def init_dons
      @dons = (@notes[DON_SMALL] + @notes[DON_BIG]).sort_by(&:time)
    end

    # 初始化蓝色音符
    def init_kas
      @kas = (@notes[KA_SMALL] + @notes[KA_BIG]).sort_by(&:time)
    end

    # 初始化黄条
    def init_rolls
      @rolls = (@notes[ROLL_SMALL] + @notes[ROLL_BIG]).sort_by(&:start_time)
    end

    # 初始化气球
    def init_balloons
      @balloons = @notes[BALLOON].sort_by(&:start_time)
      @balloons.zip(Taiko.songdata.balloons).each do |note, number|
        note.number = number
      end
    end

    # 初始化游戏结束的时间
    def init_end_time
      @end_time = @notes_for_display.map(&:end_time).max
    end
  end
end