module Preact
  module Component
    module Initializer
      def initialize(native_component)
        @native = native_component
        @props = `Opal.Preact.Component.Props.$new(#@native)`
        @state = `Opal.Preact.Component.State.$new(#@native)`
      end
    end
  end
end
