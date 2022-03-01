module Browser
  module DelegateNative
    # Provides a default initializer. This should be overridden in all but the
    # simplest cases.
    def initialize native
      @native = native
    end

    # Fall back to native properties. If the message sent to this element is not
    # recognized, it checks to see if it is a property of the native element. It
    # also checks for variations of the message name, such as:
    #
    #   :supported? => [:supported, :isSupported]
    #
    # If a property with the specified message name is found and it is a
    # function, that function is invoked with `args`. Otherwise, the property
    # is returned as is.
    def method_missing message, *args, &block
      if message.end_with? '='
        message = message.chop
        property_name = property_for_message(message)
        return `#@native[#{property_name}] = args[0]`
      else
        property_name = property_for_message(message)

        %x{
          let value = #@native[#{property_name}];
          let type = typeof(value);
          try {
            if (type === 'function') {
              return value.apply(#@native, args);
            } else if (type === 'object' && (value instanceof HTMLCollection)) {
              let a = [];
              for(let i=0; i<value.length; i++) {
                a[i] = #{Browser::Element.new(`value.item(i)`)};
              }
              value = a;
            } else if (type === 'object' && (value instanceof HTMLElement)) {
              value = #{Browser::Element.new(`value`)};
            } else if (value === null || type === 'undefined' || (type === 'number' && isNaN(value))) {
              return nil;
            }
            return value;
          } catch { return value; }
        }
      end
    end

    def respond_to_missing? message, include_all
      message = message.chop if message.end_with? '='
      property_name = property_for_message(message)
      return true unless `#{property_name} in #@native`
      false
    end

    def property_for_message(message)
      %x{
        let camel_cased_message;
        if (typeof(#@native[message]) !== 'undefined') { camel_cased_message = message; }
        else { camel_cased_message = Opal.Preact.lower_camelize(message) }

        if (camel_cased_message.endsWith('?')) {
          camel_cased_message = camel_cased_message.substring(0, camel_cased_message.length - 2);
          if (typeof(#@native[camel_cased_message]) === 'undefined') {
            camel_cased_message = 'is' + camel_cased_message[0].toUpperCase() + camel_cased_message.substring(0, camel_cased_message.length - 1);
          }
        }
        return camel_cased_message
      }
    end
  end
end
