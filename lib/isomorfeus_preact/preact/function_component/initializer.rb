module Preact
  module FunctionComponent
    module Initializer
      def initialize
        self.JS[:native_props] = `{ props: null }`
        @native_props = `Opal.Preact.Props.$new(self)`
      end
    end
  end
end
