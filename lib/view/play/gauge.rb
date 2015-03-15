# encoding: utf-8

module View
  class Play
    class Gauge

      # 素材规格的常量
      WIDTH = 300
      HEIGHT = 22
      NORMAL_X = 233  # 及格线位置

      def initialize(viewport)
        @empty = Sprite.new(viewport)
        @full = Sprite.new(viewport)
        @soul = Sprite.new(viewport)

        @empty.x = @full.x = GAUGE_X
        @soul.x = @empty.x + WIDTH - 15

        @empty.y = @full.y = GAUGE_Y
        @soul.y = GAUGE_Y - 40
        @empty.oy = @full.oy = HEIGHT / 2

        @empty.z = 100
        @full.z = @empty.z + 1
        @soul.z = @full.z + 1

        @empty.bitmap = @full.bitmap = Cache.skin('normagauge')
        @empty.src_rect = Rect.new(0, 0, WIDTH, HEIGHT)
        @full.src_rect = Rect.new(0, HEIGHT, WIDTH, HEIGHT)

        Taiko.hit_callback { |note| refresh if note.normal? }
        refresh
      end

      def update
      end

      def dispose
        @empty.dispose
        @full.dispose
        @soul.dispose
      end

      private

      def refresh
        @full.src_rect.width = fill_w(Taiko.gauge.rate)

        if Taiko.gauge.soul?
          @full.src_rect.y = HEIGHT * 3
          @soul.bitmap = Cache.skin('soul-2')
        else
          @full.src_rect.y = HEIGHT
          @soul.bitmap = Cache.skin('soul-1')
        end
      end


      # 值槽填充的宽度
      def fill_w(rate)
        n_rate = Taiko::Gauge::NORMAL_RATE
        if rate < n_rate
          # 在 rate == 0 时返回 0，
          # 在 rate == n_rate 时返回 NORMAL_X 的线性函数。
          NORMAL_X * rate / n_rate
        else
          # 在 rate == n_rate 时返回 NORMAL_X，
          # 在 rate == 1 时返回 WIDTH 的线性函数。
          WIDTH - (1 - rate) * (WIDTH - NORMAL_X) / (1 - n_rate)
        end
      end
    end
  end
end