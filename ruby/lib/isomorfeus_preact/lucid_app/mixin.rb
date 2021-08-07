module LucidApp
  module Mixin
    def self.included(base)
      base.include(::Native::Wrapper)
      base.extend(::LucidApp::NativeLucidComponentConstructor)
      if on_browser? || on_ssr?
        base.extend(::LucidApp::NativeComponentConstructor)
        base.include(::Preact::Component::Elements)
      elsif on_mobile?
        base.extend(::LucidApp::ReactNativeComponentConstructor)
        base.include(::ReactNative::Component::Elements)
      end
      base.extend(::LucidPropDeclaration::Mixin)
      base.include(::Preact::Component::Api)
      base.include(::Preact::Component::Callbacks)
      base.include(::LucidComponent::Api)
      base.include(::LucidComponent::StylesApi)
      base.include(::LucidApp::Api)
      base.include(::LucidComponent::Initializer)
      base.include(::Preact::Component::Features)
    end
  end
end
