module LucidFunc::Mixin
  def self.included(base)
    base.include(::LucidFunc::Initializer)
    base.include(::Preact::FunctionComponent::Api)
    base.extend(::LucidFunc::NativeComponentConstructor)
    base.include(::Preact::Elements)
    base.include(::LucidComponent::Api)
    base.include(::LucidI18n::Mixin) if `(Opal.modules.hasOwnProperty("lucid_i18n/mixin"))`
  end
end
