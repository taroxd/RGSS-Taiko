# encoding: utf-8

# 该类管理音符的状态和位置。
module Taiko
  module Note
    class Base

      # type -> Fixnum 范围为 0..9
      # time -> Fixnum or Range
      # speed -> Fixnum
      # status -> 返回值由子类的实现决定，伪值表示音符永久消失
      # valid? -> 等价于 status
      attr_reader :type, :time, :speed, :status
      alias_method :valid?, :status

      # start_time -> Fixnum
      # end_time -> Fixnum
      # 返回起止时间
      alias_method :start_time, :time
      alias_method :end_time, :time

      def initialize(type, time, speed)
        @type = type
        @time = time
        @speed = speed
        @status = 0
      end

      # 击打时的额外处理
      def hit
      end

      # 获取判定 -> :perfect / :great / :miss / nil
      alias_method :performance, :hit

      # 击打该音符获得的分数
      def score
        0
      end

      # x 坐标
      def x
        (start_time - Taiko.play_time) * @speed
      end

      # 原点 x 坐标
      def ox
        NOTE_SIZE / 2
      end

      # z 坐标
      def z
        Graphics.width - x.to_i
      end

      # 位图宽度
      def width
        NOTE_SIZE
      end

      # 出现的时间
      def appear_time
        start_time - (Graphics.width + ox) / @speed
      end

      # 是否已经过了准确击打的时间
      def over?
        Taiko.play_time > end_time
      end

      # 绘制位图
      def draw(bitmap)
      end

      # 获取不被缓存的音符位图
      def bitmap
        Bitmap.new(width, NOTE_SIZE).tap { |b| draw(b) }
      end

      # 音符种类的判断方法
      def normal?; false; end
      alias_method :roll?, :normal?
      alias_method :balloon?, :normal?
      alias_method :hitting?, :normal?
      alias_method :big?, :normal?
    end
  end
end
