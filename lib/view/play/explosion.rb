# encoding: utf-8

require 'view/play/explosion/upper'
require 'view/play/explosion/lower'

module View
  class Play
    class Explosion
      #--------------------------------------------------------------------------
      # ● 初始化
      #--------------------------------------------------------------------------
      def initialize(viewport_upper = nil,viewport_lower = nil)
        @sprite_upper = Upper.new(viewport_upper,
          {x: upper_pos_x, y: upper_pos_y, z: upper_pos_z},
          {frame: upper_frame_max, duration: upper_duration_time})
        @sprite_lower = Lower.new(viewport_lower,
          {x: lower_pos_x, y: lower_pos_y, z: lower_pos_z},
          {frame: lower_frame_max, duration: lower_duration_time})
      end
      #--------------------------------------------------------------------------
      # ● 上层特效X坐标
      #--------------------------------------------------------------------------
      def upper_pos_x; SkinSettings.fetch(:ExplosionUpperX); end
      #--------------------------------------------------------------------------
      # ● 上层特效Y坐标
      #--------------------------------------------------------------------------
      def upper_pos_y; SkinSettings.fetch(:ExplosionUpperY); end
      #--------------------------------------------------------------------------
      # ● 上层特效帧数
      #--------------------------------------------------------------------------
      def upper_frame_max; SkinSettings.fetch(:ExplosionUpperFrame); end
      #--------------------------------------------------------------------------
      # ● 上层特效持续时间
      #--------------------------------------------------------------------------
      def upper_duration_time; 1; end
      #--------------------------------------------------------------------------
      # ● 上层特效Z坐标
      #--------------------------------------------------------------------------
      def upper_pos_z; 0; end
      #--------------------------------------------------------------------------
      # ● 下层特效X坐标
      #--------------------------------------------------------------------------
      def lower_pos_x; SkinSettings.fetch(:ExplosionLowerX); end
      #--------------------------------------------------------------------------
      # ● 下层特效Y坐标
      #--------------------------------------------------------------------------
      def lower_pos_y; SkinSettings.fetch(:ExplosionLowerY); end
      #--------------------------------------------------------------------------
      # ● 下层特效帧数
      #--------------------------------------------------------------------------
      def lower_frame_max; SkinSettings.fetch(:ExplosionLowerFrame); end
      #--------------------------------------------------------------------------
      # ● 下层特效持续时间
      #--------------------------------------------------------------------------
      def lower_duration_time; 1; end
      #--------------------------------------------------------------------------
      # ● 下层特效Z坐标
      #--------------------------------------------------------------------------
      def lower_pos_z; 100; end
      #--------------------------------------------------------------------------
      # ● 更新
      #--------------------------------------------------------------------------
      def update
        @sprite_upper.update
        @sprite_lower.update
        return unless Taiko.last_hit
        return if @finish == Taiko.last_hit.time
        return if Taiko.last_hit.performance == :miss
        return unless Taiko.last_hit.normal?
        type = Taiko.last_hit.performance == :perfect ? 0 : 1
        type += Taiko.last_hit.double ? 2 : 0
        @finish = Taiko.last_hit.time
        @sprite_upper.reset_and_show(type)
        @sprite_lower.reset_and_show(type)
      end
      #--------------------------------------------------------------------------
      # ● 释放
      #--------------------------------------------------------------------------
      def dispose
        @sprite_upper.dispose
        @sprite_lower.dispose
      end
    end
  end
end