# encoding:utf-8

require 'scene/song_list'

module Scene

  @scene = nil                            # 当前场景实例

  # 运行
  def self.run
    @scene = first_scene_class.new
    @scene.main while @scene
  end

  # 获取最初场景的所属类
  def self.first_scene_class
    SongList
  end

  # 获取当前场景
  def self.scene
    @scene
  end

  # 判定当前场景的所属类
  def self.scene_is?(scene_class)
    @scene.instance_of?(scene_class)
  end

  # 直接切换某个场景（无过渡）
  def self.goto(scene_class)
    @scene = scene_class.new
  end

  # 退出游戏
  def self.exit
    @scene = nil
  end
end
