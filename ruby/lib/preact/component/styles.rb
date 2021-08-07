module Preact
  module Component
    class Styles

      def initialize(native, props_prop = false)
        @native = native
        @props_prop = props_prop
      end

      def [](prop)
        method_missing(prop)
      end

      def []=(prop, val)
        method_missing(prop, val)
      end

      def deep_merge(a_hash)
        native_hash = a_hash.to_n
        Preact::Component::Styles.new(`Opal.Preact.merge_deep(#@native, native_hash)`)
      end

      def deep_merge!(a_hash)
        native_hash = a_hash.to_n
        `#@native = Opal.Preact.merge_deep(#@native, native_hash)`
        self
      end

      def method_missing(prop, *args, &block)
        %x{
          let value;
          if (#@props_prop) {
            if (!#@native.props[#@props_prop] || typeof #@native.props[#@props_prop][prop] === 'undefined') {
              console.warn("Style/Theme key '" + prop + "' returning nil!");
              return #{nil};
            }
            value = #@native.props[#@props_prop][prop];
          } else {
            if (!#@native || typeof #@native[prop] === 'undefined') {
              console.warn("Style/Theme key '" + prop + "' returning nil!");
              return #{nil};
            }
            value = #@native[prop];
          }
          if (typeof value === 'string' || typeof value === 'number' || Array.isArray(value)) { return value; }
          if (typeof value === 'function') { return value.apply(#@native, args); }
          return Opal.Preact.Component.Styles.$new(value);
        }
      end

      def to_h
        %x{
          if (#@props_prop) { return Opal.Hash.$new(#@native.props[#@props_prop]); }
          else { return Opal.Hash.$new(#@native); }
        }
      end

      def to_n
        %x{
          if (#@props_prop) { return #@native.props[#@props_prop]; }
          else { return #@native; }
        }
      end
    end
  end
end
