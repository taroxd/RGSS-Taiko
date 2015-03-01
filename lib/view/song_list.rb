# encoding: utf-8

# 显示选曲界面的精灵组。

require 'view/song_list/songs'

module View
  class SongList

    def initialize
      create_viewports
      create_background
      create_songlist
    end

    def update
      update_songlist
    end

    def dispose
      dispose_background
      dispose_songlist
      dispose_viewports
    end

    private

    def create_background
      @background = Sprite.new(@viewport1)
      @background.bitmap = Cache.skin('songselectbg')
    end

    def create_viewports
      @viewport1 = Viewport.new
      @viewport2 = Viewport.new
      @viewport2.z = 50
    end

    def create_songlist
      @songlist = Songs.new(@viewport2)
    end

    def update_songlist
      @songlist.update
    end

    def dispose_background
      @background.dispose
    end

    def dispose_songlist
      @songlist.dispose
    end

    def dispose_viewports
      @viewport1.dispose
      @viewport2.dispose
    end
  end
end