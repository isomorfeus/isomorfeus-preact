module Preact
  module FunctionComponent
    module Mixin
      def self.included(base)
        if on_browser? || on_ssr? || on_mobile?
          base.include(::Preact::Component::Elements)
        end
        base.include(::Preact::Component::Features)
        base.include(::Preact::FunctionComponent::Initializer)
        base.include(::Preact::FunctionComponent::Api)
        base.extend(::Preact::FunctionComponent::NativeComponentConstructor)
      end
    end
  end
end
