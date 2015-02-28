#encoding:utf-8

require 'scene/base'
require 'scene/play'
require 'spriteset/spriteset_song_list'

#  选曲场景。
module Scene
  class SongList < Base

    include Taiko

    @@index = 0

    # 当前曲名
    def header(offset = 0)
      @songlist[(@@index + offset) % @songlist.size]
    end

    private

    # 开始处理
    def start
      Graphics.resize_screen(480, 272)
      super
      @songlist = Dir.glob("#{DIRECTORY}/**/*#{EXTNAME}").map do |name|
        SongData.header name.chomp(EXTNAME)
      end
      play_demo
      @spriteset = Spriteset_SongList.new
    end

    # 结束处理
    def terminate
      super
      @spriteset.dispose
      Graphics.resize_screen(544, 416)
      Audio.bgm_stop
    end

    # 更新
    def update
      super
      update_index
      update_spriteset
      update_scene unless scene_changing?
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

    # 更新精灵组
    def update_spriteset
      @spriteset.update
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