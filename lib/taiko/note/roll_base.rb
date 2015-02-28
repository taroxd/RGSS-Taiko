# encoding: utf-8

require 'taiko/note/base'

module Taiko
  module Note
    class RollBase < Base

      # 连打开始的时间
      def start_time
        @time.begin
      end

      # 连打结束的时间
      def end_time
        @time.end
      end

      # 是否可以击打
      def hitting?
        @time.include?(play_time)
      end

      # 显示的数字（X 连打 / 剩余 X 次）
      def number
        @status
      end
    end
  end
end