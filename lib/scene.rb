# encoding: utf-8

require 'scene/song_list'

module Scene

  class << self

    attr_reader :scene  # 获取当前场景

    # 运行
    def run
      @scene = first_scene_class.new
      @scene.main while @scene
    end

    # 获取最初场景的所属类
    def first_scene_class
      SongList
    end

    # 切换某个场景
    def goto(scene_class)
      @scene = scene_class.new
    end
  end
end
