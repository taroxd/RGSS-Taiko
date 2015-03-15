
module Taiko
  module Version
    MAJOR = 0
    MINOR = 0
    PATCH = 5

    class << self

      def to_i
        (MAJOR << 20) + (MINOR << 10) + PATCH
      end

      def to_s
        [MAJOR, MINOR, PATCH].join('.')
      end

      alias_method :inspect, :to_s
    end
  end
end
