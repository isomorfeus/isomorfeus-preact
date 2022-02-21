module Preact
  def self.render_to_string(native_preact_element)
    `Opal.global.Preact.renderToString(native_preact_element)`
  end
end

module Isomorfeus
  class TopLevel
    class << self
      attr_accessor :ssr_route_path
      attr_accessor :transport_ws_url

      def render_component_to_string(component_name, props)
        component = nil
        %x{
          if (typeof component_name === 'string' || component_name instanceof String) {
            component = component_name.split(".").reduce(function(o, x) {
              return (o !== null && typeof o[x] !== "undefined" && o[x] !== null) ? o[x] : null;
            }, Opal.global)
          } else {
            component = component_name;
          }
        }
        component = Isomorfeus.cached_component_class(component_name) unless component
        Preact.render_to_string(Preact.create_element(component, `Opal.Hash.$new(props)`))
      end
    end
  end
end
