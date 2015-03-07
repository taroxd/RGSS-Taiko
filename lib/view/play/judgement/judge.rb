# encoding: utf-8
require 'view/animation'

module View
  class Play
    class Judge < Animation
      def initialize(viewport)
        super(viewport,
          {
            x: SkinSettings.fetch(:JudgementX),
            y: SkinSettings.fetch(:JudgementY),
            z: 100,
          },
          {duration: 30}
        )
      end
      #--------------------------------------------------------------------------
      # ● 设置精灵的位图
      #--------------------------------------------------------------------------
      def get_bitmap(_)
        Cache.skin('judgement')
      end
      #--------------------------------------------------------------------------
      # ● 设置帧的高度
      #--------------------------------------------------------------------------
      def frame_height
        self.bitmap.height / 3
      end
      #--------------------------------------------------------------------------
      # ● 设置当前帧Y坐标
      #--------------------------------------------------------------------------
      def frame_y
        @frame_y || 0
      end
      #--------------------------------------------------------------------------
      # ● 重置并显示
      #--------------------------------------------------------------------------
      def reset_and_show(type)
        @frame = 0
        @frame_y = self.bitmap.height / 3 * type
        set_frame
        show
        set_change_effect
      end
      #--------------------------------------------------------------------------
      # ● 设置图像变更时的特效
      #--------------------------------------------------------------------------
      def set_change_effect
        self.y = @change_effect[1] if @change_effect
        @change_effect = [8, self.y]
        self.y += @change_effect[0]
      end
      #--------------------------------------------------------------------------
      # ● 更新图像变更时的特效
      #--------------------------------------------------------------------------
      def update_change_effect
        if @change_effect[0] > 0
          self.y -= 2
          @change_effect[0] -= 2
        end
      end
      #--------------------------------------------------------------------------
      # ● 更新
      #--------------------------------------------------------------------------
      def update
        super
        return unless self.visible
        return unless self.bitmap
        update_change_effect
      end
    end
  end
end