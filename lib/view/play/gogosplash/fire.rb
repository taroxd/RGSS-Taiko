# encoding: utf-8

require 'view/animation'

module View
  class Play
    class Gogosplash
      class Fire < Animation
        def get_bitmap(_)
          Cache.skin('Fire')
        end

        def loop?
          true
        end
      end
    end
  end
end