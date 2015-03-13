#encoding:utf-8

require 'scene/base'
require 'scene/play'
require 'scene/autoload_view'

#  选曲场景。
module Scene
  class SongList < Base

    include Taiko
    include AutoloadView

    INDEX_FILENAME = 'Data/SONGLIST_INDEX'

    # 当前曲名
    def songdata(offset = 0)
      @songlist[songlist_index(offset)]
    end

    private

    # 开始处理
    def start
      Graphics.resize_screen(480, 272)
      make_song_list
      load_index
      super
      play_demo
    end

    # 结束处理
    def terminate
      super
      Graphics.resize_screen(544, 416)
      Audio.bgm_stop
    end

    # 更新
    def update
      super
      update_index
      update_course(1)  if Input.trigger?(:RIGHT)
      update_course(-1) if Input.trigger?(:LEFT)
      update_view
      update_scene unless scene_changing?
    end

    # 读取上次的曲子位置
    def load_index
      if File.exist?(INDEX_FILENAME)
        @index, @courses = load_data(INDEX_FILENAME)
      else
        @index = 0
        @courses = Hash.new(0)
      end

      @songlist.each_with_index do |songdata, index|
        select_course(index, @courses[songdata.name])
      end
    end

    # 保存上次的曲子位置
    def save_index
      save_data([@index, @courses], INDEX_FILENAME)
    end

    # 获取取余后的索引
    def songlist_index(offset = 0)
      (@index + offset) % @songlist.size
    end

    def make_song_list
      @songlist = Dir.glob("#{DIRECTORY}/**/*#{EXTNAME}").map do |name|
        SongData.new name.chomp(EXTNAME)
      end
      if @songlist.empty?
        raise "There is no tja file in the folder `#{DIRECTORY}'!"
      end
    end

    # 更新光标
    def update_index
      last_index = @index
      if Input.repeat?(:UP)
        @index -= 1
        @index %= @songlist.size
      elsif Input.repeat?(:DOWN)
        @index += 1
        @index %= @songlist.size
      end
      if last_index != @index
        Audio.se_play 'Audio/SE/dong'
        play_demo
        save_index
      end
    end

    # 更新难度
    def update_course(course_diff)
      if select_course(@index, course_diff)
        @courses[songdata.name] += course_diff
        save_index
        Audio.se_play 'Audio/SE/dong'
      end
    end

    # 更改难度。song_index: 歌曲编号。course_diff: 更改的量。
    # 未发生更改时返回伪值。
    def select_course(song_index, course_diff)
      last_data = data = @songlist[song_index]
      to_next = course_diff > 0
      course_diff.abs.times do
        data = (to_next ? data.next_course : data.prev_course) || data
      end
      @songlist[song_index] = data
      !last_data.equal?(data)
    end

    # 播放预览
    def play_demo
      Audio.bgm_stop
      Audio.bgm_play songdata.wave, songdata.songvol, 100
    end

    def update_scene
      if Input.trigger?(:C)
        Audio.se_play 'Audio/SE/dong'
        Taiko.setup songdata
        fadeout_all(120)
        Scene.goto(Play)
      end
    end
  end
end