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

      def children
        @native.JS[:props].JS[:children]
      end

      def isomorfeus_store
        # TODO
        @native.JS[:props].JS[:isomorfeus_store]
      end

      def theme
        `#@native.props.iso_theme`
      end

      def params
        return @params if @params
        return nil if `typeof #@native.props.params === 'undefined'`
        @params = ::Preact::Component::Params.new(`#@native.props.params`)
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
