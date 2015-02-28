# encoding: utf-8
require 'taiko/note/base'

module Taiko
  module Note
    class Barline < Base

      COLOR = Color.new(238, 238, 238)

      def draw(bitmap)
        bitmap.fill_rect ox, 0, width, NOTE_SIZE, COLOR
      end

      def ox
        0
      end

      def width
        1
      end

      def z
        0
      end
    end
  end
end