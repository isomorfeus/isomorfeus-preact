module LucidComponent::Mixin
  def self.included(base)
    base.include(::Native::Wrapper)
    base.extend(::LucidComponent::NativeComponentConstructor)
    base.include(::Preact::Elements)
    base.extend(::LucidPropDeclaration::Mixin)
    base.include(::Preact::Component::Api)
    base.include(::Preact::Component::Callbacks)
    base.include(::LucidComponent::Api)
    base.include(::LucidComponent::Initializer)
    base.include(::LucidI18n::Mixin) if `("lucid_i18n/mixin" in Opal.modules)`
  end
end
