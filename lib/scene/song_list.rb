#encoding:utf-8

require 'scene/base'
require 'scene/play'
require 'scene/autoload_view'

#  选曲场景。
module Scene
  class SongList < Base

    include Taiko
    include AutoloadView

    @@index = 0

    # 当前曲名
    def songdata(offset = 0)
      @songlist[songlist_index(offset)]
    end

    private

    # 开始处理
    def start
      Graphics.resize_screen(480, 272)
      make_song_list
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
      update_course(true)  if Input.trigger?(:RIGHT)
      update_course(false) if Input.trigger?(:LEFT)
      update_scene unless scene_changing?
    end

    def songlist_index(offset = 0)
      (@@index + offset) % @songlist.size
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
      last_index = @@index
      if Input.repeat?(:UP)
        @@index -= 1
      elsif Input.repeat?(:DOWN)
        @@index += 1
      end
      if last_index != @@index
        Audio.se_play 'Audio/SE/dong'
        play_demo
      end
    end

    # 更新难度。to_next: 是否向下一难度
    def update_course(to_next)
      new_data = to_next ? songdata.next_course : songdata.prev_course
      if new_data
        @songlist[songlist_index] = new_data
        Audio.se_play 'Audio/SE/dong'
      end
    end

    # 播放预览
    def play_demo
      Audio.bgm_stop
      Audio.bgm_play songdata.wave, songdata.song_vol, 100
    end

    def update_scene
      if Input.trigger?(:C)
        Audio.se_play 'Audio/SE/dong'
        Taiko.setup songdata
        fadeout_all(120)
        Scene.call(Play)
      end
    end
  end
end