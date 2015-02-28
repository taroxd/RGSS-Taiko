#encoding:utf-8
#==============================================================================
# ■ Spriteset_judgement
#------------------------------------------------------------------------------
#  显示打击准确度的精灵
#==============================================================================

#--------------------------------------------------------------------------
# ● Sprite_Judgement
#
#   显示打击准确度的精灵，在 Spriteset_Judgement 内部使用
#--------------------------------------------------------------------------
class Sprite_Judgement < Sprite_Anime
  #--------------------------------------------------------------------------
  # ● 设置精灵的位图
  #--------------------------------------------------------------------------
  def get_bitmap(bitmap)
    Cache.skin("judgement")
  end
  #--------------------------------------------------------------------------
  # ● 设置帧的高度
  #--------------------------------------------------------------------------
  def frame_height
    self.bitmap.height / 3
  end
  #--------------------------------------------------------------------------
  # ● 设置当前帧Y坐标
  #--------------------------------------------------------------------------
  def frame_y
    @frame_y || 0
  end
  #--------------------------------------------------------------------------
  # ● 重置并显示
  #--------------------------------------------------------------------------
  def reset_and_show(type)
    @frame = 0
    @frame_y = self.bitmap.height / 3 * type
    set_frame
    show
    set_change_effect
  end
  #--------------------------------------------------------------------------
  # ● 设置图像变更时的特效
  #--------------------------------------------------------------------------
  def set_change_effect
    self.y = @change_effect[1] if @change_effect
    @change_effect = [8, self.y]
    self.y += @change_effect[0]
  end
  #--------------------------------------------------------------------------
  # ● 更新图像变更时的特效
  #--------------------------------------------------------------------------
  def update_change_effect
    if @change_effect[0] > 0
      self.y -= 2
      @change_effect[0] -= 2
    end
  end
  #--------------------------------------------------------------------------
  # ● 更新
  #--------------------------------------------------------------------------
  def update
    super
    return unless self.visible
    return unless self.bitmap
    update_change_effect
  end
end
#--------------------------------------------------------------------------
# ● Sprite_Mtaiko
#
#   显示击中音符的精灵，在 Spriteset_Judgement 内部使用
#--------------------------------------------------------------------------
class Sprite_NoteEffect < Sprite_Anime
  #--------------------------------------------------------------------------
  # ● 重置并显示
  #--------------------------------------------------------------------------
  def reset_and_show(note)
    self.bitmap = Cache.note(note)
    @frame = 0
    set_frame
    show
    set_change_effect
  end
  #--------------------------------------------------------------------------
  # ● 设置图像变更时的特效
  #--------------------------------------------------------------------------
  def set_change_effect
    self.y = @change_effect[1] if @change_effect
    self.x = @change_effect[2] if @change_effect
    @change_effect = [20, self.y, self.x]
  end
  #--------------------------------------------------------------------------
  # ● 更新图像变更时的特效
  #--------------------------------------------------------------------------
  def update_change_effect
    if @change_effect[0] > 0
      self.y -= 5
      @change_effect[0] -= 2
    end
  end
  #--------------------------------------------------------------------------
  # ● 更新
  #--------------------------------------------------------------------------
  def update
    super
    return unless self.visible
    return unless self.bitmap
    update_change_effect
  end
end
#--------------------------------------------------------------------------
# ● Spriteset_Judgement
#
#   显示打击准确度的精灵
#--------------------------------------------------------------------------
class Spriteset_Judgement < Spriteset_M5
  #--------------------------------------------------------------------------
  # ● 初始化
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    @note = Sprite_NoteEffect.new(viewport,
      {x: note_pos_x, y: note_pos_y, z: note_pos_z},
      {duration: note_duration_time})
    @judge = Sprite_Judgement.new(viewport,
      {x: judge_pos_x, y: judge_pos_y, z: judge_pos_z},
      {duration: judge_duration_time})
  end
  #--------------------------------------------------------------------------
  # ● 弹起音符X坐标
  #--------------------------------------------------------------------------
  def note_pos_x; Skin_Setting.setting(:NoteEffectX); end
  #--------------------------------------------------------------------------
  # ● 弹起音符Y坐标
  #--------------------------------------------------------------------------
  def note_pos_y; Skin_Setting.setting(:NoteEffectY); end
  #--------------------------------------------------------------------------
  # ● 弹起音符Z坐标
  #--------------------------------------------------------------------------
  def note_pos_z; 0; end
  #--------------------------------------------------------------------------
  # ● 弹起音符持续时间
  #--------------------------------------------------------------------------
  def note_duration_time; 10; end
  #--------------------------------------------------------------------------
  # ● 判定X坐标
  #--------------------------------------------------------------------------
  def judge_pos_x; Skin_Setting.setting(:JudgementX); end
  #--------------------------------------------------------------------------
  # ● 判定Y坐标
  #--------------------------------------------------------------------------
  def judge_pos_y; Skin_Setting.setting(:JudgementY); end
  #--------------------------------------------------------------------------
  # ● 判定Z坐标
  #--------------------------------------------------------------------------
  def judge_pos_z; 100; end
  #--------------------------------------------------------------------------
  # ● 判定持续时间
  #--------------------------------------------------------------------------
  def judge_duration_time; 30; end
  #--------------------------------------------------------------------------
  # ● 更新
  #--------------------------------------------------------------------------
  def update
    super
    @judge.update
    @note.update
    return unless Taiko.last_hit
    return if @finish == Taiko.last_hit.time
    type = case Taiko.last_hit.performance
           when :miss    then 2
           when :great   then 1
           else               0
           end
    @finish = Taiko.last_hit.time
    @judge.reset_and_show(type) unless Taiko.last_hit.valid?
    @note.reset_and_show(Taiko.last_hit) unless type == 2
  end
  #--------------------------------------------------------------------------
  # ● 释放
  #--------------------------------------------------------------------------
  def dispose
    super
    @judge.dispose
    @note.dispose
  end
end