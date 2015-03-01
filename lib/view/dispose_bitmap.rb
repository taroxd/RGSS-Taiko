
module View
  module DisposeBitmap
    def dispose
      bitmap.dispose if bitmap
      super
    end
  end
end