module Preact
  module Component
    class Props
      def initialize(native)
        @native = native
      end

      def method_missing(prop, *args, &block)
        %x{
          const p = #@native.props;
          if (typeof p[prop] === 'undefined') {
            prop = Opal.Preact.lower_camelize(prop);
            if (typeof p[prop] === 'undefined') { return nil; }
          }
          return p[prop];
        }
      end

      def classes
        @classes ||= Preact::Component::Styles.new(@native, 'classes')
      end

      def children
        @native.JS[:props].JS[:children]
      end

      def theme
        @theme ||= Preact::Component::Styles.new(@native, 'theme')
      end

      def isomorfeus_store
        @native.JS[:props].JS[:isomorfeus_store]
      end

      # for router convenience
      def history
        return @history if @history
        return nil if `typeof #@native.props.history === 'undefined'`
        if `typeof #@native.props.history.action !== 'undefined'`
          @history = Preact::Component::History.new(@native)
        else
          @native.JS[:props].JS[:history]
        end
      end

      def location
        return @location if @location
        return nil if `typeof #@native.props.location === 'undefined'`
        if `typeof #@native.props.location.pathname !== 'undefined'`
          @location = Preact::Component::Location.new(@native)
        else
          @native.JS[:props].JS[:location]
        end
      end

      def match
        return @match if @match
        return nil if `typeof #@native.props.match === 'undefined'`
        if `typeof #@native.props.match.path !== 'undefined'`
          @match = Preact::Component::Match.new(@native)
        else
          @native.JS[:props].JS[:match]
        end
      end

      def to_h
        `Opal.Hash.$new(#@native.props)`.transform_keys!(&:underscore)
      end

      def to_json
        JSON.dump(to_transport)
      end

      def to_n
        @native.JS[:props]
      end

      def to_transport
        {}.merge(to_h)
      end
    end
  end
end
