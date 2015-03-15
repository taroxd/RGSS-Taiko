#encoding:utf-8

# 依序修改图像实现动画效果的精灵（只播放一次）

module View
  class Animation < Sprite

    # Animation.new(viewport, x: 233, bitmap: 'something')
    def initialize(viewport, options = {})
      super(viewport)

      self.x = options[:x] || x
      self.y = options[:y] || y
      self.z = options[:z] || z

      self.bitmap = get_bitmap(options[:bitmap]) || raise(TypeError, 'bitmap not given')
      @max_frame = options.fetch(:frame, 1)
      @frame_duration = @duration = options.fetch(:duration, 1)
      @loop = options[:loop]
      self.frame_y = options.fetch(:frame_y, 0)

      reset(false)
    end

    # virtual
    # 当前帧高度
    def frame_height
      self.bitmap.height
    end

    # 更新当前帧位置
    def update_frame
      if loop?
        @frame == @max_frame - 1 ? @frame = 0 : @frame += 1
      else
        @frame == @max_frame ? hide : @frame += 1
      end
    end

    def update
      super
      return unless self.visible
      return unless self.bitmap
      @duration > 0 ? @duration -= 1 : set_frame
    end

    def show
      self.visible = true
    end

    def hide
      self.visible = false
    end

    # virtual
    # 是否循环播放
    def loop?
      @loop
    end

    def reset(show = true)
      @frame = 0
      set_frame
      self.visible = show
    end

    protected

    # virtual
    # 当前帧的 y 坐标
    attr_accessor :frame_y

    private

    # virtual
    # 获取使用的位图
    def get_bitmap(bitmap)
      Cache.try_convert(bitmap)
    end

    # 设置当前帧图像
    def set_frame
      width = self.bitmap.width / @max_frame
      self.src_rect = Rect.new(@frame * width, frame_y, width, frame_height)
      @duration = @frame_duration
      update_frame
    end
  end
end
