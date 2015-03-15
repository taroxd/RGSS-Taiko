# encoding: utf-8

require 'view/animation'

module View
  class Play
    class MTaiko

      # 初始化
      def initialize(viewport = nil)
        temp_bitmap = Cache.skin('mtaikoflash_red')
        @li = Animation.new(viewport,
          x: MTAIKO_LIX, y: MTAIKO_LIY, z: pos_z,
            bitmap: get_bitmap(temp_bitmap, 0), duration: duration_time)
        @ri = Animation.new(viewport,
          x: MTAIKO_RIX, y: MTAIKO_RIY, z: pos_z,
            bitmap: get_bitmap(temp_bitmap, 1), duration: duration_time)

        temp_bitmap = Cache.skin('mtaikoflash_blue')
        @lo = Animation.new(viewport,
          x: MTAIKO_LOX, y: MTAIKO_LOY, z: pos_z,
            bitmap: get_bitmap(temp_bitmap, 0), duration: duration_time)
        @ro = Animation.new(viewport,
          x: MTAIKO_ROX, y: MTAIKO_ROY, z: pos_z,
            bitmap: get_bitmap(temp_bitmap, 1), duration: duration_time)

        @sfr = Animation.new(viewport,
          x: MTAIKO_SFX, y: MTAIKO_SFY, z: pos_z,
            bitmap: Cache.skin('sfieldflash_red'), duration: duration_time)
        @sfb = Animation.new(viewport,
          x: MTAIKO_SFX, y: MTAIKO_SFY, z: pos_z,
            bitmap: Cache.skin('sfieldflash_blue'), duration: duration_time)
        @sfg = Animation.new(viewport,
          x: MTAIKO_SFX, y: MTAIKO_SFY, z: pos_z,
            bitmap: Cache.skin('sfieldflash_gogotime'), duration: duration_time)

        @views = [@li, @ri, @lo, @ro, @sfr, @sfb, @sfg]
      end

      # 释放
      def dispose
        @views.each do |v|
          v.bitmap.dispose
          v.dispose
        end
      end

      # 更新
      def update
        update_taiko
        update_fumen
        @views.each(&:update)
      end

      private

      # 更新太鼓打击特效
      def update_taiko
        @lo.reset if Keyboard.left_outer?
        @ro.reset if Keyboard.right_outer?
        @li.reset if Keyboard.left_inner?
        @ri.reset if Keyboard.right_inner?
      end

      # 更新谱面打击特效
      def update_fumen
        if Taiko.gogotime?
          @sfg.reset
        else
          @sfg.hide
          if Keyboard.outer?
            @sfr.hide
            @sfb.reset
          end
          if Keyboard.inner?
            @sfr.reset
            @sfb.hide
          end
        end
      end

      # 切割图片
      def get_bitmap(temp_bitmap, type = 0)
        target_bitmap = Bitmap.new(temp_bitmap.width/2,temp_bitmap.height)
        src_rect = Rect.new(temp_bitmap.width/2 * type, 0,
          target_bitmap.width, target_bitmap.height)
        target_bitmap.blt(0, 0, temp_bitmap, src_rect)
        target_bitmap
      end

      # Z 坐标
      def pos_z
        0
      end

      # 显示时间
      def duration_time
        5
      end
    end
  end
end