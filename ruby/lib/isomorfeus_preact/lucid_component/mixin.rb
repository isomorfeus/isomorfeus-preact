module LucidComponent
  module Mixin
    def self.included(base)
      base.include(::Native::Wrapper)
      base.extend(::LucidComponent::NativeLucidComponentConstructor)
      base.extend(::LucidComponent::NativeComponentConstructor)
      base.include(::Preact::Component::Elements)
      base.extend(::LucidPropDeclaration::Mixin)
      base.include(::Preact::Component::Api)
      base.include(::Preact::Component::Callbacks)
      base.include(::LucidComponent::Api)
      base.include(::LucidComponent::StylesApi)
      base.include(::LucidComponent::Initializer)
      base.include(::Preact::Component::Features)
    end
  end
end
