module Preact
  module Component
    class Match
      include ::Native::Wrapper

      def initialize(native)
        @native = native
      end

      def method_missing(prop, *args, &block)
        @native.JS[:props].JS[:match].JS[:params].JS[prop]
      end

      def is_exact
        @native.JS[:props].JS[:match].JS[:isExact]
      end

      def params
        self
      end

      def path
        @native.JS[:props].JS[:match].JS[:path]
      end

      def url
        @native.JS[:props].JS[:match].JS[:url]
      end

      def to_n
        @native.JS[:props].JS[:match]
      end
    end
  end
end
