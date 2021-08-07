module Preact
  module Component
    module Features
      def Fragment(*args, &block)
        `Opal.Preact.internal_prepare_args_and_render(Opal.global.Preact.Fragment, args, block)`
      end
    end
  end
end
