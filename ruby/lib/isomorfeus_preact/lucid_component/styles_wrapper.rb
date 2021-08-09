module LucidComponent
  class StylesWrapper
    include ::Native::Wrapper

    def fade_in
      'fadeIn'
    end

    def fade_out
      'fadeOut'
    end

    def [](prop)
      method_missing(prop)
    end

    def method_missing(prop, *args, &block)
      %x{
        let value;
        value = #@native[prop];
        if (value) { return value; }
        else {
          console.warn("Style/Theme key '" + prop + "' returning nil!");
          return #{nil};
        }
      }
    end

    def to_h
      %x{
        if (#@props_prop) { return Opal.Hash.$new(#@native.props[#@props_prop]); }
        else { return Opal.Hash.$new(#@native); }
      }
    end
  end
end
