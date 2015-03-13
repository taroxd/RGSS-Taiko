
# 包含该模块后，场景会自动读取 View 文件夹中的内容

module Scene
  module AutoloadView

    private

    def view_class
      basename = self.class.name[/\w+\Z/]
      require "view/#{to_underscore(basename)}.rb"
      View.const_get(basename)
    end

    def to_underscore(word)
      word.gsub(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
        .gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
    end

    def start
      super
      @view = view_class.new
      update_view
    end

    # 这个方法需要主动调用
    def update_view
      @view.update
    end

    def terminate
      super
      @view.dispose
    end
  end
end