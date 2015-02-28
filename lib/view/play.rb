# encoding: utf-8

require 'spriteset/spriteset_background'
require 'spriteset/spriteset_gogosplash'
require 'spriteset/spriteset_mtaiko'
require 'view/fumen'
require 'spriteset/spriteset_score'
require 'spriteset/spriteset_combo'
require 'sprite/sprite_explosion'
require 'sprite/sprite_judgement'

module View

  class Play

    # 初始化对象
    def initialize
      load_song_skin
      create_viewports
      create_all_views
    end

    # 读取歌曲的自定义皮肤
    def load_song_skin
      Skin_Setting.load_song_setting(Taiko.songdata.name)
    end

    # 更新
    def update
      update_all_views
    end

    # 释放
    def dispose
      dispose_all_views
      dispose_viewports
    end

    private

    # 生成显示端口
    def create_viewports
      @viewport1 = Viewport.new
      @viewport2 = Viewport.new(fumen_x,fumen_y,Graphics.width,Graphics.height)
      @viewport3 = Viewport.new
      @viewport2.z = 50
      @viewport3.z = 100
      @viewport2.ox = note_x
    end

    def create_all_views
      @views = [
        Spriteset_Background.new(@viewport1),
        Spriteset_Gogosplash.new(@viewport1),
        Spriteset_Mtaiko.new(@viewport1),
        Fumen.new(@viewport2),
        Spriteset_Score.new(@viewport3),
        Spriteset_Combo.new(@viewport3),
        Spriteset_Explosion.new(@viewport3, @viewport1),
        Spriteset_Judgement.new(@viewport3)
      ]
    end

    # 获取谱面X坐标
    def fumen_x; Skin_Setting.setting(:FumenX); end

    # 获取谱面Y坐标
    def fumen_y; Skin_Setting.setting(:FumenY); end

    # 获取音符判定点X坐标
    def note_x; Skin_Setting.setting(:NoteX); end

    def update_all_views
      @views.each(&:update)
    end

    def dispose_all_views
      @views.each(&:dispose)
    end

    # 释放显示端口
    def dispose_viewports
      @viewport1.dispose
      @viewport2.dispose
      @viewport3.dispose
    end
  end
end
