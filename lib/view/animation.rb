#encoding:utf-8

# 依序修改图像实现动画效果的精灵（只播放一次）

require 'view/dispose_bitmap'

module View
  class Animation < Sprite
    include DisposeBitmap
    #--------------------------------------------------------------------------
    # ● 初始化
    #--------------------------------------------------------------------------
    def initialize(viewport = nil, pos = {}, bitmap = {})
      super(viewport)
      set_pos(pos[:x], pos[:y], pos[:z])
      set_bitmap(bitmap[:filename], bitmap[:frame], bitmap[:duration])
      hide
    end
    #--------------------------------------------------------------------------
    # ● 获取使用的位图
    #--------------------------------------------------------------------------
    def get_bitmap(filename)
      Cache.empty_bitmap
    end
    #--------------------------------------------------------------------------
    # ● 设置位置
    #--------------------------------------------------------------------------
    def set_pos(x, y, z)
      self.x, self.y, self.z = x || 0, y || 0, z || 0
    end
    #--------------------------------------------------------------------------
    # ● 设置位图
    #--------------------------------------------------------------------------
    def set_bitmap(filename, frame, duration)
      self.bitmap.dispose if self.bitmap
      self.bitmap = get_bitmap(filename || "")
      @max_frame = [frame || 1,1].max.to_i
      @frame_duration = @duration = duration || 1
      @frame = 0
      set_frame
    end
    #--------------------------------------------------------------------------
    # ● 设置当前帧图像
    #--------------------------------------------------------------------------
    def set_frame
      width = self.bitmap.width / @max_frame
      rect_new = Rect.new(@frame * width, frame_y, width, frame_height)
      self.src_rect.set(rect_new)
      @duration = @frame_duration
      update_frame
    end
    #--------------------------------------------------------------------------
    # ● 设置当前帧Y坐标
    #--------------------------------------------------------------------------
    def frame_y
      0
    end
    #--------------------------------------------------------------------------
    # ● 设置当前帧高度
    #--------------------------------------------------------------------------
    def frame_height
      self.bitmap.height
    end
    #--------------------------------------------------------------------------
    # ● 更新当前帧位置
    #--------------------------------------------------------------------------
    def update_frame
      if loop?
        @frame == @max_frame - 1 ? @frame = 0 : @frame += 1
      else
        @frame == @max_frame ? hide : @frame += 1
      end
    end
    #--------------------------------------------------------------------------
    # ● 刷新
    #--------------------------------------------------------------------------
    def update
      super
      return unless self.visible
      return unless self.bitmap
      @duration > 0 ? @duration -= 1 : set_frame
    end
    #--------------------------------------------------------------------------
    # ● 显示
    #--------------------------------------------------------------------------
    def show; self.visible = true ; end
    #--------------------------------------------------------------------------
    # ● 隐藏
    #--------------------------------------------------------------------------
    def hide; self.visible = false; end

    # 是否循环播放
    def loop?
      false
    end
  end
end
