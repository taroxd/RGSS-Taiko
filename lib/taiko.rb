# encoding: utf-8

#  此模块管理全局数据，并作为游戏对象的命名空间使用。

require 'taiko/fumen'
require 'taiko/song_data'
require 'taiko/gauge'

module Taiko

  # 游戏常量
  VERSION = 0.04                     # 当前版本
  VALID_OLDEST_VERSION = 0.01        # 分数有效的最低版本

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

  #  存档的游戏数据
  #    键与值的对应关系:
  #      max_combo: 最大连击数
  #      perfect/great/miss：对应判定的数量
  #      version: 存档时游戏版本
  #      normal_clear: 是否达到及格线
  EMPTY_PLAYDATA = {score: 0, max_combo: 0,
                    perfect: 0, great: 0, miss: 0, version: VERSION}
  PLAYDATA = Hash[EMPTY_PLAYDATA]

  # 临时数据，作用类似于全局变量。
  # 请勿在 Taiko 模块之外访问该常量。
  EMPTY_GLOBAL = {combo: 0}
  GLOBAL = Hash[EMPTY_GLOBAL]

  module_function

  # 获取全局数据
  def songdata;   GLOBAL[:songdata];       end    # 歌曲信息（SongData）
  def last_hit;   GLOBAL[:last_hit];       end    # 最后一次击打的音符（Note）
  def start_time; GLOBAL[:start_time];     end    # 游戏开始时间（毫秒）或 nil
  def combo;      GLOBAL[:combo];          end    # 当前连击数
  def fumen;      GLOBAL[:fumen];          end    # 谱面（Fumen）
  def gauge;      GLOBAL[:gauge];          end    # 魂槽（Gauge）
  def play_time;  GLOBAL[:play_time] || 0; end    # 游戏时间（毫秒）
  def score;      PLAYDATA[:score];        end    # 当前分数
  def songvol;   songdata.songvol;         end    # 歌曲音量
  def sevol;     songdata.sevol;           end    # 音效音量
  def scoreinit; songdata.scoreinit;       end    # 初项
  def scorediff; songdata.scorediff;       end    # 公差
  alias_method :started?, :start_time
  module_function :started?

  # 游戏是否结束
  def gameover?
    started? && play_time > fumen.end_time
  end

  # 是否在 gogotime 中
  def gogotime?
    songdata.gogotimes.any? { |range| range.include?(play_time) }
  end

  # 准确率
  def accuracy
    count = perfect + great + miss
    count.zero? ? 0 : (perfect * 100 + great * 50) / count
  end

  class << self
    # 开始游戏
    def start
      Audio.me_play(songdata.wave, songvol)
      GLOBAL[:start_time] = msec
      update_time
    end

    # 准备
    def setup(songdata)
      clear
      GLOBAL[:songdata] = songdata
      init_game_objects
    end

    # 停止
    def stop
      Cache.clear_rolls
      Audio.me_stop
      save if gameover?
    end

    # 击打音符
    def hit(note)
      GLOBAL[:last_hit] = note
      note.hit
      on_hit
    end

    # 更新时间
    def update_time
      GLOBAL[:play_time] = time = msec - start_time
    end

    # 检查版本并读取 playdata
    def load(name)
      filename = make_filename(name)
      data = load_data(filename)
      return data if data[:version].between?(VALID_OLDEST_VERSION, VERSION)
      nil
    rescue
      nil
    end

    # 如果获得最高成绩，保存 playdata
    def save
      name = songdata.name
      old_data = load(name)
      if score > (old_data ? old_data[:score] : 0)
        new_data = Hash[PLAYDATA]
      else
        new_data = old_data
      end
      new_data[:normal_clear] = gauge.normal? || old_data[:normal_clear]
      save_data(new_data, make_filename(name))
    end

    private

    # 生成存档的文件名
    def make_filename(name)
      "#{name}.rvdata2"
    end

    # 初始化游戏对象
    def init_game_objects
      GLOBAL[:fumen] = Fumen.new
      GLOBAL[:gauge] = Gauge.new
    end

    # 清除当前游戏信息
    def clear
      PLAYDATA.replace EMPTY_PLAYDATA
      GLOBAL.replace   EMPTY_GLOBAL
    end

    # 保存时的处理
    def on_save
      PLAYDATA[:normal_clear] = true if gauge.normal?
    end

    # 击打时的处理
    def on_hit
      performance = last_hit.performance
      PLAYDATA[:score] += last_hit.score
      return unless performance
      gauge << performance
      case performance
      when :perfect, :great
        GLOBAL[:combo] = combo + 1
        PLAYDATA[:max_combo] = combo if PLAYDATA[:max_combo] < combo
      when :miss
        GLOBAL[:combo] = 0
      end
      PLAYDATA[performance] += 1
    end

    # 获取当前毫秒数
    def msec
      t = Time.now
      t.to_i * 1000 + t.usec / 1000
    end
  end
end