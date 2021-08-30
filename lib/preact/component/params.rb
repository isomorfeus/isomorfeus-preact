module Preact
  module Component
    class Params
      include Native::Wrapper

      def method_missing(prop, *args, &block)
        %x{
          const p = #@native;
          if (typeof p[prop] === 'undefined') {
            prop = Opal.Preact.lower_camelize(prop);
            if (typeof p[prop] === 'undefined') { return nil; }
          }
          return p[prop];
        }
      end
    end
  end
end
