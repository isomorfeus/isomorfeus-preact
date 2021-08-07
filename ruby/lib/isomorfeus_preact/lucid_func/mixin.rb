module LucidFunc
  module Mixin
    def self.included(base)
      base.include(::Preact::Component::Features)
      base.include(::LucidFunc::Initializer)
      base.include(::Preact::FunctionComponent::Api)
      if on_browser?  || on_ssr?
        base.extend(::LucidFunc::NativeComponentConstructor)
        base.include(::Preact::Component::Elements)
      elsif on_mobile?
        base.extend(::LucidFunc::ReactNativeComponentConstructor)
        base.include(::ReactNative::Component::Elements)
      end
      base.include(::LucidComponent::Api)
      base.include(::LucidComponent::StylesApi)
    end
  end
end
