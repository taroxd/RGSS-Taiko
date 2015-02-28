# encoding: utf-8

require 'taiko/note/barline'
require 'taiko/note/normal'
require 'taiko/note/roll'
require 'taiko/note/balloon'

module Taiko
  module Note

    TYPES = [Barline, Normal, Normal, Normal, Normal, Roll, Roll, Balloon]

    # 生成一个 Note::Base 或其子类的实例。类型由 type 参数决定。
    def self.[](type, time, speed)
      TYPES[type].new(type, time, speed)
    end
  end
end