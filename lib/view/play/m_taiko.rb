# encoding: utf-8

require 'view/play/m_taiko/m_taikoh.rb'

module View
  class Play
  class MTaiko
    #--------------------------------------------------------------------------
    # ● 初始化
      #--------------------------------------------------------------------------
      def initialize(viewport = nil)
        temp_bitmap = Cache.skin("mtaikoflash_red")
        @li = MTaikoh.new(viewport,
          {x: li_pos_x, y: li_pos_y, z: pos_z},
          {filename: get_bitmap(temp_bitmap, 0), duration: duration_time})
        @ri = MTaikoh.new(viewport,
          {x: ri_pos_x, y: ri_pos_y, z: pos_z},
          {filename: get_bitmap(temp_bitmap, 1), duration: duration_time})
        temp_bitmap.dispose
        temp_bitmap = Cache.skin("mtaikoflash_blue")
        @lo = MTaikoh.new(viewport,
          {x: lo_pos_x, y: lo_pos_y, z: pos_z},
          {filename: get_bitmap(temp_bitmap, 0), duration: duration_time})
        @ro = MTaikoh.new(viewport,
          {x: ro_pos_x, y: ro_pos_y, z: pos_z},
          {filename: get_bitmap(temp_bitmap, 1), duration: duration_time})
        temp_bitmap.dispose
        @sfr = MTaikoh.new(viewport,
          {x: sf_pos_x, y: sf_pos_y, z: pos_z},
          {filename: Cache.skin("sfieldflash_red"), duration: duration_time})
        @sfb = MTaikoh.new(viewport,
          {x: sf_pos_x, y: sf_pos_y, z: pos_z},
          {filename: Cache.skin("sfieldflash_blue"), duration: duration_time})
        @sfg = MTaikoh.new(viewport,
          {x: sf_pos_x, y: sf_pos_y, z: pos_z},
          {filename: Cache.skin("sfieldflash_gogotime"), duration: duration_time})
      end
      #--------------------------------------------------------------------------
      # ● 释放
      #--------------------------------------------------------------------------
      def dispose
        @li.dispose
        @ri.dispose
        @lo.dispose
        @ro.dispose
        @sfr.dispose
        @sfb.dispose
        @sfg.dispose
      end
      #--------------------------------------------------------------------------
      # ● 更新
      #--------------------------------------------------------------------------
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
      #--------------------------------------------------------------------------
      # ● 更新太鼓打击特效
      #--------------------------------------------------------------------------
      def update_taiko
        @lo.show if Keyboard.left_outer?
        @ro.show if Keyboard.right_outer?
        @li.show if Keyboard.left_inner?
        @ri.show if Keyboard.right_inner?
      end
      #--------------------------------------------------------------------------
      # ● 更新谱面打击特效
      #--------------------------------------------------------------------------
      def update_fumen
        if Taiko.gogotime? then @sfg.show
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
      #--------------------------------------------------------------------------
      # ● 切割图片
      #--------------------------------------------------------------------------
      def get_bitmap(temp_bitmap,type = 0)
        target_bitmap = Bitmap.new(temp_bitmap.width/2,temp_bitmap.height)
        src_rect = Rect.new(temp_bitmap.width/2 * type, 0,
          target_bitmap.width, target_bitmap.height)
        target_bitmap.blt(0, 0, temp_bitmap, src_rect)
        return target_bitmap
      end
      #--------------------------------------------------------------------------
      # ● Z 坐标
      #--------------------------------------------------------------------------
      def pos_z; 0; end
      #--------------------------------------------------------------------------
      # ● 显示时间
      #--------------------------------------------------------------------------
      def duration_time; 5; end
      #--------------------------------------------------------------------------
      # ● 太鼓左侧中心位置
      #--------------------------------------------------------------------------
      def li_pos_x; Skin_Setting.setting(:MtaikoLIX); end
      def li_pos_y; Skin_Setting.setting(:MtaikoLIY); end
      #--------------------------------------------------------------------------
      # ● 太鼓左侧外部位置
      #--------------------------------------------------------------------------
      def lo_pos_x; Skin_Setting.setting(:MtaikoLOX); end
      def lo_pos_y; Skin_Setting.setting(:MtaikoLOY); end
      #--------------------------------------------------------------------------
      # ● 太鼓右侧中心位置
      #--------------------------------------------------------------------------
      def ri_pos_x; Skin_Setting.setting(:MtaikoRIX); end
      def ri_pos_y; Skin_Setting.setting(:MtaikoRIY); end
      #--------------------------------------------------------------------------
      # ● 太鼓右侧外部位置
      #--------------------------------------------------------------------------
      def ro_pos_x; Skin_Setting.setting(:MtaikoROX); end
      def ro_pos_y; Skin_Setting.setting(:MtaikoROY); end
      #--------------------------------------------------------------------------
      # ● 谱面闪烁位置
      #--------------------------------------------------------------------------
      def sf_pos_x; Skin_Setting.setting(:MtaikoSFX); end
      def sf_pos_y; Skin_Setting.setting(:MtaikoSFY); end
    end
  end
end