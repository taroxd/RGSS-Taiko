# encoding: utf-8

require 'cache'

module View

  NOTE_SIZE = Taiko::NOTE_SIZE

  # 分数
  SCORE_X = 528
  SCORE_Y = 113
  SCORE_X2 = 528
  SCORE_Y2 = 88

  # 连击数
  COMBO_NUMBER_X = 47
  COMBO_NUMBER_Y = 150
  COMBO_NUMBER_INTERVAL = 0

  # 连击数（50连）
  COMBO_NUMBER_X2 = 47
  COMBO_NUMBER_Y2 = 146
  COMBO_NUMBER_INTERVAL2 = -10

  # 连击数特效（50连）
  MTAIKOFLOWER_X = 3
  MTAIKOFLOWER_Y = 124
  MTAIKOFLOWER_DURATION = 30

  # 太鼓按键效果持续时间
  MTAIKO_DURATION = 5

  # 太鼓左侧中心
  MTAIKO_LIX = 2
  MTAIKO_LIY = 115

  # 太鼓左侧外部
  MTAIKO_LOX = 2
  MTAIKO_LOY = 115

  # 太鼓右侧中心
  MTAIKO_RIX = 47
  MTAIKO_RIY = 115

  # 太鼓右侧外部
  MTAIKO_ROX = 47
  MTAIKO_ROY = 115

  # 谱面闪烁位置
  MTAIKO_SFX = 92
  MTAIKO_SFY = 149

  # 谱面背景
  SFIELDBG_X = 0
  SFIELDBG_Y = 121

  # 谱面
  FUMEN_X = 92
  FUMEN_Y = 149

  # 判定点的 X 偏移
  NOTE_X = 35

  # GOGO_TIME
  GOGOSPLASH = 5     # 数目
  GOGO_FRAME = 20    # 帧数
  GOGO_WIDTH = -60   # 间距调整

  # gogotime 判定点火焰特效
  FIRE_X = 33
  FIRE_Y = 87
  FIRE_FRAME = 8

  # 上层打击特效
  EXPLOSION_UPPER_X = 52
  EXPLOSION_UPPER_Y = 103
  EXPLOSION_UPPER_FRAME = 9

  # 下层打击特效
  EXPLOSION_LOWER_X = 87
  EXPLOSION_LOWER_Y = 138
  EXPLOSION_LOWER_FRAME = 9

  # 判定
  JUDGEMENT_X = 100
  JUDGEMENT_Y = 110

  # 魂槽
  GAUGE_X = 200
  GAUGE_Y = 27

  # 音符弹起效果
  NOTE_FLY_DURATION = 20  # 影响持续时间和 Y 方向的加速度
  NOTE_FLY_ACC_Y = 0.5    # Y 方向的加速度补正

  # 连打气泡
  ROLL_BALLOON_X = 50
  ROLL_BALLOON_Y = 0
  # 连打气泡中的数字
  ROLL_BALLOON_NUMBER_DX = 66
  ROLL_BALLOON_NUMBER_DY = 22
  ROLL_BALLOON_INTERVAL = -5
end