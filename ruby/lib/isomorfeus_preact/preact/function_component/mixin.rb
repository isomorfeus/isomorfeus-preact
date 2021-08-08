module Preact
  module FunctionComponent
    module Mixin
      def self.included(base)
        base.include(::Preact::Component::Elements)
        base.include(::Preact::Component::Features)
        base.include(::Preact::FunctionComponent::Initializer)
        base.include(::Preact::FunctionComponent::Api)
        base.extend(::Preact::FunctionComponent::NativeComponentConstructor)
      end
    end
  end
end
