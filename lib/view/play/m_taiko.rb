# encoding: utf-8

require 'view/animation'
require 'view/dispose_bitmap'

module View
  class Play
    class MTaiko
      class MTaikoh < Animation
        include DisposeBitmap

        def show
          @frame = 0
          set_frame
          super
        end
      end

      # 初始化
      def initialize(viewport = nil)
        temp_bitmap = Cache.skin('mtaikoflash_red')
        @li = MTaikoh.new(viewport,
          {x: MTAIKO_LIX, y: MTAIKO_LIY, z: pos_z},
          {filename: get_bitmap(temp_bitmap, 0), duration: duration_time})
        @ri = MTaikoh.new(viewport,
          {x: MTAIKO_RIX, y: MTAIKO_RIY, z: pos_z},
          {filename: get_bitmap(temp_bitmap, 1), duration: duration_time})

        temp_bitmap = Cache.skin('mtaikoflash_blue')
        @lo = MTaikoh.new(viewport,
          {x: MTAIKO_LOX, y: MTAIKO_LOY, z: pos_z},
          {filename: get_bitmap(temp_bitmap, 0), duration: duration_time})
        @ro = MTaikoh.new(viewport,
          {x: MTAIKO_ROX, y: MTAIKO_ROY, z: pos_z},
          {filename: get_bitmap(temp_bitmap, 1), duration: duration_time})

        @sfr = MTaikoh.new(viewport,
          {x: MTAIKO_SFX, y: MTAIKO_SFY, z: pos_z},
          {filename: Cache.skin('sfieldflash_red'), duration: duration_time})
        @sfb = MTaikoh.new(viewport,
          {x: MTAIKO_SFX, y: MTAIKO_SFY, z: pos_z},
          {filename: Cache.skin('sfieldflash_blue'), duration: duration_time})
        @sfg = MTaikoh.new(viewport,
          {x: MTAIKO_SFX, y: MTAIKO_SFY, z: pos_z},
          {filename: Cache.skin('sfieldflash_gogotime'), duration: duration_time})
      end

      # 释放
      def dispose
        @li.dispose
        @ri.dispose
        @lo.dispose
        @ro.dispose
        @sfr.dispose
        @sfb.dispose
        @sfg.dispose
      end

      # 更新
      def update
        update_taiko
        update_fumen
        @li.update
        @lo.update
        @ri.update
        @ro.update
        @sfr.update
        @sfb.update
      end

      # 更新太鼓打击特效
      def update_taiko
        @lo.show if Keyboard.left_outer?
        @ro.show if Keyboard.right_outer?
        @li.show if Keyboard.left_inner?
        @ri.show if Keyboard.right_inner?
      end

      # 更新谱面打击特效
      def update_fumen
        if Taiko.gogotime?
          @sfg.show
        else
          @sfg.hide
          if Keyboard.outer?
            @sfr.hide
            @sfb.show
          end
          if Keyboard.inner?
            @sfr.show
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