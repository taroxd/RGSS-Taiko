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
    def header(offset = 0)
      @songlist[(@@index + offset) % @songlist.size]
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
      update_scene unless scene_changing?
    end

    def make_song_list
      @songlist = Dir.glob("#{DIRECTORY}/**/*#{EXTNAME}").map do |name|
        SongData.header name.chomp(EXTNAME)
      end
      if @songlist.empty?
        raise "There is no .tja file in the directory `#{DIRECTORY}'!"
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

    # 播放预览
    def play_demo
      Audio.bgm_stop
      Audio.bgm_play header.wave, header.song_vol, 100
    end


    def update_scene
      if Input.trigger?(:C)
        Audio.se_play 'Audio/SE/dong'
        Taiko.setup header.name
        fadeout_all(120)
        Scene.call(Play)
      end
    end
  end
end