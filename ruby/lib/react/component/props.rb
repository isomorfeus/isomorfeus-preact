module React
  module Component
    class Props
      include ::Native::Wrapper

      def method_missing(prop, *args, &block)
        %x{
          var prop_name = Opal.React.lower_camelize(prop);
          if (typeof #@native.props[prop_name] === 'undefined') { return #{nil}; }
          return #@native.props[prop_name];
        }
      end

      def classes
        @classes ||= `Opal.React.Component.Styles.$new(#@native.classes)`
      end

      def isomorfeus_store
        @native.JS[:props].JS[:isomorfeus_store]
      end

      # for router convenience
      def history
        return @history if @history
        return nil unless @native.JS[:props].JS[:history]
        if @native.JS[:props].JS[:history].JS[:pathname]
          @history = React::Component::History.new(@native.JS[:props].JS[:history])
        else
          @native.JS[:props].JS[:history]
        end
      end

      def location
        return @location if @location
        return nil unless @native.JS[:props].JS[:location]
        if @native.JS[:props].JS[:location].JS[:pathname]
          @location = React::Component::Location.new(@native.JS[:props].JS[:location])
        else
          @native.JS[:props].JS[:location]
        end
      end

      def match
        return @match if @match
        return nil unless @native.JS[:props].JS[:match]
        if @native.JS[:props].JS[:match].JS[:path]
          @match = React::Component::Match.new(@native.JS[:props].JS[:match])
        else
          @native.JS[:props].JS[:match]
        end
      end

      def to_n
        @native.JS[:props]
      end
    end
  end
end