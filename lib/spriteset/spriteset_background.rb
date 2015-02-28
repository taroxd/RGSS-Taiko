#encoding:utf-8
#==============================================================================
# ■ Spriteset_Background
#------------------------------------------------------------------------------
#  显示背景的精灵组
#==============================================================================

require 'sprite/sprite_m5'

class Spriteset_Background < Spriteset_M5
  #--------------------------------------------------------------------------
  # ● 初始化
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    @scene_back = Sprite_M5.new(viewport)
    @scene_back.bitmap = Cache.skin('bg')
    @fumen_back = Sprite_M5.new(viewport)
    @fumen_back.bitmap = Cache.skin('sfieldbg')
    @fumen_back.x = Skin_Setting.setting(:SfieldbgX)
    @fumen_back.y = Skin_Setting.setting(:SfieldbgY)
  end
  #--------------------------------------------------------------------------
  # ● 释放
  #--------------------------------------------------------------------------
  def dispose
    super
    @fumen_back.dispose
    @scene_back.dispose
  end
  #--------------------------------------------------------------------------
  # ● 设置Z坐标
  #--------------------------------------------------------------------------
  def z=(value)
    @scene_back.z = value
    @fumen_back.z = value
  end
end
