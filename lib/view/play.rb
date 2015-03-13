# encoding: utf-8

require 'view/play/background'
require 'view/play/gogosplash'
require 'view/play/m_taiko'
require 'view/play/fumen'
require 'view/play/combo'
require 'view/play/explosion'
require 'view/play/judgement'
require 'view/play/note_fly'
require 'view/play/gauge'
require 'view/play/roll_balloon'
require 'view/score'


module View

  class Play

    # 初始化对象
    def initialize
      create_viewports
      create_all_views
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
        Background.new(@viewport1),
        Gogosplash.new(@viewport1),
        MTaiko.new(@viewport1),
        RollBalloon.new(@viewport1),
        Fumen.new(@viewport2),
        Score.new(@viewport3),
        Combo.new(@viewport3),
        Gauge.new(@viewport1),
        Explosion.new(@viewport3, @viewport1),
        Judgement.new(@viewport3),
        NoteFly.new(@viewport3)
      ]
    end

    # 获取谱面X坐标
    def fumen_x; SkinSettings.fetch(:FumenX); end

    # 获取谱面Y坐标
    def fumen_y; SkinSettings.fetch(:FumenY); end

    # 获取音符判定点X坐标
    def note_x; SkinSettings.fetch(:NoteX); end

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
