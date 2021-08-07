module Preact
  module FunctionComponent
    class Base
      def self.inherited(base)
        base.include(::Preact::FunctionComponent::Mixin)
      end
    end
  end
end