module LucidFunc
  module Mixin
    def self.included(base)
      base.include(::LucidFunc::Initializer)
      base.include(::Preact::FunctionComponent::Api)
      base.extend(::LucidFunc::NativeComponentConstructor)
      base.include(::Preact::Elements)
      base.include(::LucidComponent::Api)
      base.include(::LucidI18n::Mixin) if `("lucid_i18n/mixin" in Opal.modules)`
    end
  end
end
