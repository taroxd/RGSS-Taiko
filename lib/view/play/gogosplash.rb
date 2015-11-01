# encoding: utf-8

# 显示喷烟特效的精灵组

require 'view/animation'

module View
  class Play
    class Gogosplash

      # 初始化
      def initialize(viewport1)
        @viewport = viewport1
        @fire = Animation.new(viewport1,
          x: FIRE_X, y: FIRE_Y, z: 100, loop: true,
          frame: FIRE_FRAME, duration: 3, bitmap: 'Fire')
        @bitmap = Cache.skin('gogosplash')
        set_spriteset
      end

      # 更新
      def update
        if @gogotime && !Taiko.gogotime?
          @fire.hide
          @gogotime = false
        elsif Taiko.gogotime?
          show
        end
        @fire.update
        @sprite_list.each(&:update)
      end

      # 释放
      def dispose
        @sprite_list.each(&:dispose)
        @fire.dispose
      end

      private

      # 设置精灵
      def set_spriteset
        @sprite_list.each(&:dispose) if @sprite_list
        @sprite_list = Array.new(GOGOSPLASH) do |i|
          Animation.new(@viewport,
            x: pos_x(i), y: pos_y, z: pos_z, bitmap: @bitmap, frame: GOGO_FRAME)
        end
      end

      # 显示特效
      def show
        @gogotime = true
        set_spriteset
        @sprite_list.each(&:show)
        @fire.show
      end

      # 特效 X 坐标
      def pos_x(i)
        total = (@bitmap.width / GOGO_FRAME + GOGO_WIDTH) * (GOGOSPLASH - 1) +
          @bitmap.width / GOGO_FRAME
        (Graphics.width - total) / 2 + (@bitmap.width / GOGO_FRAME + GOGO_WIDTH) * i
      end

      # 特效 Y 坐标
      def pos_y
        Graphics.height - @bitmap.height
      end

      # 特效 Z 高度
      def pos_z
        0
      end
    end
  end
end