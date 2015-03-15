# encoding: utf-8

#  此模块管理全局数据，并作为游戏对象的命名空间使用。

require 'taiko/version'
require 'taiko/playdata'
require 'taiko/fumen'
require 'taiko/songdata'
require 'taiko/gauge'

module Taiko

  # 游戏常量
  VERSION = Version.to_i

  # 判定等级
  PERFECT_JUDGE = 25
  GREAT_JUDGE = 75
  MISS_JUDGE = 108
  DOUBLE_TOLERANCE = 2               # 同时按下的允许误差

  # 文件设置
  DIRECTORY = 'Songs'                # 谱面文件的位置
  EXTNAME = '.tja'                   # 谱面文件的扩展名

  # 音符种类，请勿修改！
  BARLINE    = 0
  DON_SMALL  = 1
  KA_SMALL   = 2
  DON_BIG    = 3
  KA_BIG     = 4
  ROLL_SMALL = 5
  ROLL_BIG   = 6
  BALLOON    = 7

  # 音符大小，请勿修改！
  NOTE_SIZE = 60                     # 音符的整体大小
  NOTE_SIZE_SMALL = 34               # 小音符的大小
  NOTE_SIZE_BIG = 52                 # 大音符的大小

  @combo = 0

  class << self
    # 获取全局数据
    attr_reader :playdata
    attr_reader :last_hit               # 最后一次击打的音符（Note）
    attr_reader :start_time             # 游戏开始时间（毫秒数 或 nil）
    alias_method :started?, :start_time # 游戏是否开始
    attr_reader :combo                  # 当前连击数
    attr_reader :fumen                  # 谱面（Fumen）
    attr_reader :gauge                  # 魂槽（Gauge）
    attr_reader :songdata               # 歌曲信息（Songdata）

    def play_time;  @play_time || 0;         end    # 游戏时间（毫秒）
    def score;      playdata.score;          end    # 当前分数
    def accuracy;   playdata.accuracy;       end    # 准确率
    def songvol;    songdata.songvol;        end    # 歌曲音量
    def sevol;      songdata.sevol;          end    # 音效音量
    def scoreinit;  songdata.scoreinit;      end    # 初项
    def scorediff;  songdata.scorediff;      end    # 公差

    # 游戏是否结束
    def gameover?
      started? && play_time > fumen.end_time
    end

    # 是否在 gogotime 中
    def gogotime?
      songdata.gogotimes.any? { |range| range.include?(play_time) }
    end

    # 开始游戏
    def start
      Audio.me_play(songdata.wave, songvol)
      @start_time = msec
      update_time
    end

    # 准备
    def setup(songdata)
      clear
      @playdata = Playdata.new
      @songdata = songdata
      @fumen = Fumen.new(songdata)
      @gauge = Gauge.new(@fumen)
    end

    # 清空数据
    def clear
      @combo = 0
      @hit_callbacks = []
      @start_time = nil
      @play_time = nil
      @last_hit = nil
    end

    # 停止
    def stop
      Cache.clear_rolls
      Audio.me_stop
      @playdata.save if gameover?
    end

    # 击打音符
    def hit(note)
      @last_hit = note
      note.hit
      on_hit
      @hit_callbacks.each { |c| c.call(note) }
    end

    # 在每次击打时，以击打的 note 为参数调用 callback 或 block。
    def hit_callback(callback = nil, &block)
      @hit_callbacks.push(callback) if callback
      @hit_callbacks.push(block) if block
    end

    # 更新时间
    def update_time
      @play_time = msec - start_time
    end

    private

    # 击打时的处理
    def on_hit
      performance = last_hit.performance
      playdata.score += last_hit.score
      return unless performance
      gauge << performance
      case performance
      when :perfect, :great
        @combo += 1
        playdata.max_combo = combo if playdata.max_combo < combo
      when :miss
        @combo = 0
      end
      playdata[performance] += 1
    end

    # 获取当前毫秒数
    def msec
      t = Time.now
      t.to_i * 1000 + t.usec / 1000
    end
  end
end