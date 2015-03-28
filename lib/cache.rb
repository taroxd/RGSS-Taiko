#encoding:utf-8
#==============================================================================
# ■ Cache
#------------------------------------------------------------------------------
#  此模块载入所有图像，建立并保存 Bitmap 对象。为加快载入速度并节省内存，
#  此模块将以建立的 bitmap 对象保存在内部哈希表中，使得程序在需要已存在
#  的图像时能快速读取 bitmap 对象。
#==============================================================================

module Cache
  @cache = {}

  class << self

    # 读取位图
    def load_bitmap(folder_name, filename)
      if filename.empty?
        empty_bitmap
      else
        normal_bitmap(folder_name + filename)
      end
    end

    # 生成空位图
    def empty_bitmap
      load('') { Bitmap.new(32, 32) }
    end

    # 生成／获取普通的位图
    def normal_bitmap(path)
      load(path) { Bitmap.new(path) }
    end

    # 生成／获取色相变化后的位图
    def hue_changed_bitmap(path, hue)
      key = [path, hue]
      unless include?(key)
        @cache[key] = normal_bitmap(path).clone
        @cache[key].hue_change(hue)
      end
      @cache[key]
    end

    # load(key) { |key| bitmap }
    # 读取缓存中以 key 为键的位图。
    # 如果位图不存在，会调用 block 并将返回值加入缓存
    # 如果位图不存在且没有 block，返回 nil
    def load(key)
      bitmap = @cache[key]
      if !bitmap || bitmap.disposed?
        @cache[key] = yield key if block_given?
      else
        bitmap
      end
    end

    # 检查缓存是否存在
    alias_method :include?, :load

    # 音符的位图
    def notes
      skin('notes')
    end

    # 单个音符的位图
    def note(note)
      load("note-#{note.type}-#{note.width}") do
        note.bitmap
      end
    end

    # 音符的头部位图
    def note_head(type)
      load("note-#{type}-#{Taiko::NOTE_SIZE}") do
        Taiko::Note[type, 0..0, 0].bitmap
      end
    end

    # 删除缓存中的连打音符
    def clear_rolls
      @cache.delete_if do |key, bitmap|
        if key.kind_of?(String) && key.start_with?('note-5', 'note-6')
          bitmap.dispose
          true
        end
      end
    end

    # 皮肤的位图
    def skin(filename)
      load_bitmap('Skin/', filename)
    end

    # 当 param 为字符串时，返回 Skin 的位图
    # 当 param 为位图时，返回 param
    # 其他情况下返回 nil。
    def try_convert(param)
      case param
      when String
        skin(param)
      when Bitmap
        param
      end
    end
  end
end