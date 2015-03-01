# encoding: utf-8

require 'view/play/explosion/base'

module View
  class Play
    class Explosion
      class Upper < Base
        def get_bitmap(bitmap)
          Cache.skin("explosion_upper")
        end
      end
    end
  end
end