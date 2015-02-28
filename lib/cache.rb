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

  # 获取系统图像
  def self.system(filename)
    load_bitmap("Graphics/System/", filename)
  end

  # 读取位图
  def self.load_bitmap(folder_name, filename)
    if filename.empty?
      empty_bitmap
    else
      normal_bitmap(folder_name + filename)
    end
  end

  # 生成空位图
  def self.empty_bitmap
    Bitmap.new(32, 32)
  end

  # 生成／获取普通的位图
  def self.normal_bitmap(path)
    @cache[path] = Bitmap.new(path) unless include?(path)
    @cache[path]
  end

  # 生成／获取色相变化后的位图
  def self.hue_changed_bitmap(path, hue)
    key = [path, hue]
    unless include?(key)
      @cache[key] = normal_bitmap(path).clone
      @cache[key].hue_change(hue)
    end
    @cache[key]
  end

  # 检查缓存是否存在
  def self.include?(key)
    @cache[key] && !@cache[key].disposed?
  end
end

class << Cache

  # 音符的位图
  def notes
    skin('notes')
  end

  # 单个音符的位图
  def note(note)
    key = "note-#{note.type}-#{note.width}"
    return @cache[key] if include? key
    bitmap = Bitmap.new(note.width, Taiko::NOTE_SIZE)
    note.draw(bitmap)
    @cache[key] = bitmap
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
    load_bitmap("Skin/", filename)
  end

  # 跳舞者的位图
  def dancer(filename)
    load_bitmap("Skin/dancer/", filename)
  end
end