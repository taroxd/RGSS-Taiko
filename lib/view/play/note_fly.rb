# encoding: utf-8

require 'view/view_container'

module View
  class Play
    class NoteFly < ViewContainer

      d = NOTE_FLY_DURATION

      # 起始点
      x0 = FUMEN_X - NOTE_X
      y0 = FUMEN_Y + NOTE_SIZE / 2

      # 终点
      x1 = GAUGE_X + 311
      y1 = GAUGE_Y

      # 开口程度
      a = NOTE_FLY_ACC_Y

      # 计算加权平均
      weighted_average = lambda do |x, y, wx, wy|
        (x * wx + y * wy).fdiv(wx + wy)
      end

      # x 方向匀速运动
      GET_X = Hash.new do |h, t|
        h[t] = weighted_average[x0, x1, d - t, t]
      end

      # y 方向匀加速运动
      GET_Y = Hash.new do |h, t|
        h[t] = weighted_average[y0, y1, d - t, t] - t * (d - t) * a
      end

      def initialize(viewport)
        super(Note, viewport)

        Taiko.hit_callback do |note|
          yield_view do |v|
            v.show(note) if note.performance != :miss && !note.balloon?
          end
        end
      end

      class Note < Sprite

        def initialize(_)
          super
          self.ox = self.oy = NOTE_SIZE / 2
          @t = 0
          self.visible = false
        end

        def show(note)
          @t = 0
          self.bitmap = Cache.note_head(note.type)
          self.visible = true
        end

        def update
          if @t <= NOTE_FLY_DURATION
            self.x = GET_X[@t]
            self.y = GET_Y[@t]
            @t += 1
          else
            self.visible = false
          end
        end
      end
    end
  end
end