module LucidApp
  module Mixin
    def self.included(base)
      base.include(::Native::Wrapper)
      base.extend(::LucidApp::NativeComponentConstructor)
      base.include(::Preact::Component::Elements)
      base.extend(::LucidPropDeclaration::Mixin)
      base.include(::Preact::Component::Api)
      base.include(::Preact::Component::Callbacks)
      base.include(::LucidComponent::Api)
      base.include(::LucidComponent::StylesApi)
      base.include(::LucidApp::Api)
      base.include(::LucidComponent::Initializer)
    end
  end
end
