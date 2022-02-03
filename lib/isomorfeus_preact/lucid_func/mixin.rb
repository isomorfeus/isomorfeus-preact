module LucidFunc
  module Mixin
    def self.included(base)
      base.include(::LucidFunc::Initializer)
      base.include(::Preact::FunctionComponent::Api)
      base.extend(::LucidFunc::NativeComponentConstructor)
      base.include(::Preact::Elements)
      base.include(::LucidComponent::Api)
      base.include(::LucidComponent::StylesApi)
    end
  end
end
