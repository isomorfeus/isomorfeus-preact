module Preact
  module Component
    class History
      include ::Native::Wrapper

      def initialize(native)
        @native = native
      end
      
      def block(prompt)
        @native.JS[:props].JS[:history].JS.block(prompt)
      end

      def create_href(location)
        @native.JS[:props].JS[:history].JS.createHref(location)
      end

      def go(n)
        @native.JS[:props].JS[:history].JS.go(n)
      end

      def go_back
        @native.JS[:props].JS[:history].JS.goBack()
      end

      def go_forward
        @native.JS[:props].JS[:history].JS.goForward()
      end

      def push(*args)
        @native.JS[:props].JS[:history].JS.push(*args)
      end

      def replace(*args)
        @native.JS[:props].JS[:history].JS.replace(*args)
      end

      def method_missing(prop, *args, &block)
        @native.JS[:props].JS[:history].JS[prop]
      end

      def listen(&block)
        fun = nil
        %x{
          fun = function(location, action) {
            let ruby_location = #{Preact::Component::Location.new(`{ props: { location: location }}`)}
            block.$call(ruby_location, action);
          }
        }
        unlisten = @native.JS[:props].JS[:history].JS.listen(fun)
        -> { unlisten.JS.call() }
      end

      def location
        return @location if @location
        return nil unless @native.JS[:props].JS[:history].JS[:location]
        if @native.JS[:props].JS[:history].JS[:location].JS[:pathname]
          @location = Preact::Component::Location.new(@native)
        else
          @native.JS[:props].JS[:history].JS[:location]
        end
      end

      def to_n
        @native.JS[:props].JS[:history]
      end
    end
  end
end
