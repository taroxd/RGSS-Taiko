# encoding: utf-8

require 'spriteset/spriteset_background'
require 'spriteset/spriteset_gogosplash'
require 'spriteset/spriteset_mtaiko'
require 'spriteset/spriteset_note'
require 'spriteset/spriteset_score'
require 'spriteset/spriteset_combo'
require 'sprite/sprite_explosion'
require 'sprite/sprite_judgement'

class Spriteset_Play

  # 初始化对象
  def initialize
    load_song_skin
    create_viewports
    create_notes
    create_score
    create_combo
    creat_background
    creat_gogo_time
    create_mtaiko
    creat_explosion
    creat_judgement
  end

  # 读取歌曲的自定义皮肤
  def load_song_skin
    Skin_Setting.load_song_setting(Taiko.songdata.name)
  end

  # 更新
  def update
    update_notes
    update_all_m5_sprite
  end

  # 释放
  def dispose
    dispose_notes
    dispose_all_m5_sprite
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

  # 获取谱面X坐标
  def fumen_x; Skin_Setting.setting(:FumenX); end

  # 获取谱面Y坐标
  def fumen_y; Skin_Setting.setting(:FumenY); end

  # 获取音符判定点X坐标
  def note_x; Skin_Setting.setting(:NoteX); end

  # 创建背景的精灵组
  def creat_background
    @background_spriteset = Spriteset_Background.new(@viewport1)
    @background_spriteset.z = -200
  end

  # 创建GogoTime特效的精灵组
  def creat_gogo_time
    @gogosplash_spriteset = Spriteset_Gogosplash.new(@viewport1)
  end

  # 创建按键打击特效的精灵组
  def create_mtaiko
    @mtaiko_spriteset = Spriteset_Mtaiko.new(@viewport1)
  end

  # 创建音符的精灵组
  def create_notes
    @note_spriteset = Spriteset_Note.new(@viewport2)
  end

  # 创建分数的精灵组
  def create_score
    @score_spriteset = Spriteset_Score.new(@viewport3)
  end

  # 创建连击数的精灵组
  def create_combo
    @combo_spriteset = Spriteset_Combo.new(@viewport3)
  end

  # 创建打击特效的精灵组
  def creat_explosion
    @explosion_spriteset = Spriteset_Explosion.new(@viewport3,@viewport1)
  end

  # 创建打击准确度的精灵组
  def creat_judgement
    @judgement_spriteset = Spriteset_Judgement.new(@viewport3)
  end

  # 更新音符的精灵组
  def update_notes
    @note_spriteset.update
  end

  # 释放音符的精灵组
  def dispose_notes
    @note_spriteset.dispose
  end

  # 释放显示端口
  def dispose_viewports
    @viewport1.dispose
    @viewport2.dispose
    @viewport3.dispose
  end

  # 更新所有 m5 sprite
  def update_all_m5_sprite
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.update if ivar.is_a?(Spriteset_M5)
    end
  end

  # 释放所有 m5 sprite
  def dispose_all_m5_sprite
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.dispose if ivar.is_a?(Spriteset_M5)
    end
  end
end
