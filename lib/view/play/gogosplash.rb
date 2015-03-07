# encoding: utf-8

# 显示喷烟特效的精灵组

require 'view/animation'

module View
  class Play
    class Gogosplash

      class Fire < Animation
        def get_bitmap(_)
          Cache.skin('Fire')
        end

        def loop?
          true
        end
      end

      class GogoAnimation < Animation
        # 精灵的位图由调用者提供
        def get_bitmap(bitmap)
          bitmap
        end
      end

      # 初始化
      def initialize(viewport1 = nil, viewport2 = nil)
        @viewport = viewport1
        @bitmap ||= get_bitmap
        @gogotime = false
        @fire = Fire.new(viewport1,
          {x: fire_pos_x, y: fire_pos_y, z: fire_pos_z},
          {frame: fire_frame_max, duration: fire_duration_time})
        set_spritest
      end

      # 更新
      def update
        if @gogotime
          if !Taiko.gogotime?
            @fire.hide
            @gogotime = false
          end
        else show if Taiko.gogotime?
        end
        @fire.update
        @sprite_list.each(&:update)
      end

      # 释放
      def dispose
        @sprite_list.compact!
        @sprite_list.each(&:dispose)
        @fire.dispose
      end

      # 获取位图
      def get_bitmap
        Cache.skin("gogosplash")
      end

      # 设置精灵
      def set_spritest
        @sprite_list ||= []
        @sprite_list.compact!
        @sprite_list.each(&:dispose)
        @sprite_list = Array.new(sprite_max) do |i|
          GogoAnimation.new(@viewport,
            {x: pos_x(i), y: pos_y, z: pos_z},
            {filename: @bitmap,frame: frame_max,duration: duration_time})
        end
      end

      # 显示特效
      def show
        @gogotime = true
        set_spritest
        @sprite_list.each(&:show)
        @fire.show
      end

      # 获取特效个数
      def sprite_max; SkinSettings.fetch(:Gogosplash); end

      # 获取帧个数
      def frame_max; SkinSettings.fetch(:GogoFrame); end

      # 特效每帧持续时间
      def duration_time; 1; end

      # 特效 X 坐标
      def pos_x(i = 0)
        total = (@bitmap.width / frame_max + pos_width) * (sprite_max - 1) +
          @bitmap.width / frame_max
        (Graphics.width - total) / 2 + (@bitmap.width / frame_max + pos_width) * i
      end

      # 特效 Y 坐标
      def pos_y; Graphics.height - @bitmap.height; end

      # 特效 Z 高度
      def pos_z; 0; end

      # 特效间距的调整
      def pos_width; SkinSettings.fetch(:GogoWidth); end

      # 音符特效 X 坐标
      def fire_pos_x; SkinSettings.fetch(:FireX); end

      # 音符特效 Y 坐标
      def fire_pos_y; SkinSettings.fetch(:FireY); end

      # 音符特效 Z 坐标
      def fire_pos_z; 100; end

      # 音符特效帧数
      def fire_frame_max; SkinSettings.fetch(:FireFrame); end

      # 音符特效每帧持续时间
      def fire_duration_time; 3; end
    end
  end
end