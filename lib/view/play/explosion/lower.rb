# encoding: utf-8

require 'view/play/explosion/base'

module View
  class Play
    class Explosion
      class Lower < Base
        def get_bitmap(bitmap)
          Cache.skin("explosion_lower")
        end
      end
    end
  end
end