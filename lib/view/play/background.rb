#encoding:utf-8

module View
  class Play
    class Background
      #--------------------------------------------------------------------------
      # ● 初始化
      #--------------------------------------------------------------------------
      def initialize(viewport = nil)
        @scene_back = Sprite.new(viewport)
        @scene_back.bitmap = Cache.skin('bg')
        @fumen_back = Sprite.new(viewport)
        @fumen_back.bitmap = Cache.skin('sfieldbg')
        @fumen_back.x = SkinSettings.fetch(:SfieldbgX)
        @fumen_back.y = SkinSettings.fetch(:SfieldbgY)
        self.z = -200
      end
      #--------------------------------------------------------------------------
      # ● 释放
      #--------------------------------------------------------------------------
      def dispose
        @fumen_back.dispose
        @scene_back.dispose
      end

      def update
      end
      #--------------------------------------------------------------------------
      # ● 设置Z坐标
      #--------------------------------------------------------------------------
      def z=(value)
        @scene_back.z = value
        @fumen_back.z = value
      end
    end
  end
end