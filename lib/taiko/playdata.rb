# encoding: utf-8
# 该类管理存档的游戏数据

module Taiko
  Playdata = Struct.new(:score, :max_combo, :perfect, :great, :miss, :normal_clear, :version) do

    def self.make_filename(name)
      "#{name}.rvdata2"
    end

    # 读档
    def self.load(name)
      filename = make_filename(name)

      data = File.exist?(filename) && load_data(filename)

      case data
      when self
        data
      when Hash
        from_hash(data)
      else
        new
      end
    end

    def self.from_hash(hash)
      new.tap do |data|
        data.members.each { |name| data[name] = hash[name] }
      end
    end

    def initialize
      self.score = 0
      self.max_combo = 0
      self.perfect = 0
      self.great = 0
      self.miss = 0
      self.normal_clear = false
      self.version = VERSION
    end

    alias_method :normal_clear?, :normal_clear

    def empty?
      score.zero?
    end

    # 保存至文件
    def save
      name = Taiko.songdata.name
      old_data = self.class.load(name)

      if score > old_data.score
        new_data = dup
      else
        new_data = old_data
      end

      new_data.normal_clear = Taiko.gauge.normal? || old_data.normal_clear?
      save_data(new_data, self.class.make_filename(name))
    end

    # 准确率
    def accuracy
      count = perfect + great + miss
      count.zero? ? 0 : (perfect + great * 0.5) / count
    end
  end
end