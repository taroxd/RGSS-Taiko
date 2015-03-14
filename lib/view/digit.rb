# encoding: utf-8
#  显示一位数字的精灵类，在 Number 内部使用

module View
  class Digit < Sprite
    def initialize(viewport, bitmap)
      super(viewport)
      self.bitmap = bitmap
      @width = self.bitmap.width / 10
      clear
    end

    def clear
      self.visible = false
    end

    # 显示数字
    def show(num)
      self.src_rect.set(num * @width, 0, @width, self.bitmap.height)
      self.visible = true
    end
  end
end