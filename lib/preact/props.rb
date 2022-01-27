module Preact
  class Props
    def initialize(native)
      @native = native
    end

    def ==(other_props)
      %x{
        if (Opal.Preact.props_are_equal(#@native.props, #{other_props.to_n})) { return true; }
        return false;
      }
    end

    def [](prop)
      %x{
        const p = #@native.props;
        if (typeof p[prop] === 'undefined') {
          prop = Opal.Preact.lower_camelize(prop);
          if (typeof p[prop] === 'undefined') { return nil; }
        }
        return p[prop];
      }
    end

    def key?(k)
      %x{
        if (typeof #@native.props[k] !== 'undefined') { return true; }
        return false;
      }
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

    def theme
      `#@native.props.iso_theme`
    end

    def params
      return @params if @params
      return nil if `typeof #@native.props.params === 'undefined'`
      @params = `Opal.Preact.Params.$new(#@native.props.params)`
    end

    def to_h
      `Opal.Hash.$new(#@native.props)`.transform_keys!(&:underscore)
    end

    def to_json
      JSON.dump(to_transport)
    end

    def to_n
      `#@native.props`
    end

    def to_transport
      {}.merge(to_h)
    end
  end
end
