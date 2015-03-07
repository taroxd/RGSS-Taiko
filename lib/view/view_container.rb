# encoding: utf-8

# 放置多个 view 的容器。
module View
  class ViewContainer

    include Enumerable

    attr_reader :viewport, :size

    def initialize(view_class, viewport = nil)
      @view_class = view_class
      @viewport = viewport if viewport
      @views = []
      @size = 0
    end

    # 移除无效的 view，并更新每个有效的 view
    def update
      each(&:update)
      shift_all_invalid
    end

    def dispose
      @views.each(&:dispose)
    end

    # 迭代每个有效的 view
    def each
      @size.times { |i| yield @views[i] }
    end

    # 移除无效的 view
    def shift_all_invalid
      nil while shift_invalid
    end

    # 取出一个无效的 view 并 yield。
    # 可以通过 yield 使这个 view 有效化。
    def yield_view
      view = @views[@size] ||= make_new_view
      @size += 1
      yield view
    end

    private

    # 以下方法可以在子类定义。

    # 生成新的 view。
    def make_new_view
      @view_class.new(@viewport)
    end

    # 判断一个 view 是否有效。
    def valid?(view)
      view.visible
    end

    # 移除一个无效的 view。
    # 返回移除的 view 或 nil（没有发生移除）。
    def shift_invalid
      return if @size.zero?
      view = @views.first
      return if valid?(view)
      @views.rotate!
      @size -= 1
      view
    end
  end
end