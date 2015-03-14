# encoding: utf-8

module View
  class Play
    class Background
      def initialize(viewport = nil)
        @scene_back = Sprite.new(viewport)
        @scene_back.bitmap = Cache.skin('bg')
        @fumen_back = Sprite.new(viewport)
        @fumen_back.bitmap = Cache.skin('sfieldbg')
        @fumen_back.x = SFIELDBG_X
        @fumen_back.y = SFIELDBG_Y
        self.z = -200
      end

      def dispose
        @fumen_back.dispose
        @scene_back.dispose
      end

      def update
      end

      def z=(value)
        @scene_back.z = value
        @fumen_back.z = value
      end
    end
  end
end