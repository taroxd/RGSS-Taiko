# encoding: utf-8

require 'view/animation'

module View
  class Play
    class MTaiko

      # 初始化
      def initialize(viewport = nil)

        z = 0
        temp_bitmap = Cache.skin('mtaikoflash_red')
        @li = Animation.new(viewport,
          x: MTAIKO_LIX, y: MTAIKO_LIY, z: z,
            bitmap: get_bitmap(temp_bitmap, 0), duration: MTAIKO_DURATION)
        @ri = Animation.new(viewport,
          x: MTAIKO_RIX, y: MTAIKO_RIY, z: z,
            bitmap: get_bitmap(temp_bitmap, 1), duration: MTAIKO_DURATION)

        temp_bitmap = Cache.skin('mtaikoflash_blue')
        @lo = Animation.new(viewport,
          x: MTAIKO_LOX, y: MTAIKO_LOY, z: z,
            bitmap: get_bitmap(temp_bitmap, 0), duration: MTAIKO_DURATION)
        @ro = Animation.new(viewport,
          x: MTAIKO_ROX, y: MTAIKO_ROY, z: z,
            bitmap: get_bitmap(temp_bitmap, 1), duration: MTAIKO_DURATION)

        @sfr = Animation.new(viewport,
          x: MTAIKO_SFX, y: MTAIKO_SFY, z: z,
            bitmap: Cache.skin('sfieldflash_red'), duration: MTAIKO_DURATION)
        @sfb = Animation.new(viewport,
          x: MTAIKO_SFX, y: MTAIKO_SFY, z: z,
            bitmap: Cache.skin('sfieldflash_blue'), duration: MTAIKO_DURATION)
        @sfg = Animation.new(viewport,
          x: MTAIKO_SFX, y: MTAIKO_SFY, z: z,
            bitmap: Cache.skin('sfieldflash_gogotime'), duration: MTAIKO_DURATION)

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
    end
  end
end