module Preact
  module Component
    module Initializer
      def initialize(native_component)
        @native = native_component
        @props = `Opal.Preact.Props.$new(#@native)`
        @state = `Opal.Preact.State.$new(#@native)`
      end
    end
  end
end
