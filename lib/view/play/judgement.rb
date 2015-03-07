# encoding: utf-8
# 显示打击准确度的效果

require 'view/animation'

module View
  class Play
    class Judgement < Animation

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

      def update
        return unless Taiko.last_hit
        if @last_hit != Taiko.last_hit
          @last_hit = Taiko.last_hit
          reset_and_show if @last_hit.normal?
        end

        super
        return unless self.visible
        return unless self.bitmap
        update_change_effect
      end

      private

      def reset_judge
        type = case @last_hit.performance
        when :miss  then 2
        when :great then 1
        else             0
        end
        reset_and_show(type)
      end

      def get_bitmap(_)
        Cache.skin('judgement')
      end

      # 设置帧的高度
      def frame_height
        self.bitmap.height / 3
      end

      # 设置当前帧Y坐标
      def frame_y
        @frame_y || 0
      end

      # 重置并显示
      def reset_and_show
        type = case @last_hit.performance
        when :miss  then 2
        when :great then 1
        else             0
        end
        @frame = 0
        @frame_y = self.bitmap.height / 3 * type
        set_frame
        show
        set_change_effect
      end

      # 设置图像变更时的特效
      def set_change_effect
        self.y = @change_effect[1] if @change_effect
        @change_effect = [8, self.y]
        self.y += @change_effect[0]
      end

      # 更新图像变更时的特效
      def update_change_effect
        if @change_effect[0] > 0
          self.y -= 2
          @change_effect[0] -= 2
        end
      end
    end
  end
end