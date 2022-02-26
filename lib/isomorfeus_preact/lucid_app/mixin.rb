module LucidApp::Mixin
  def self.included(base)
    base.include(::Native::Wrapper)
    base.extend(::LucidApp::NativeComponentConstructor)
    base.include(::Preact::Elements)
    base.extend(::LucidPropDeclaration::Mixin)
    base.include(::Preact::Component::Api)
    base.include(::Preact::Component::Callbacks)
    base.include(::LucidComponent::Api)
    base.include(::LucidApp::Api)
    base.include(::LucidComponent::Initializer)
    base.include(::LucidI18n::Mixin) if `(Opal.modules.hasOwnProperty("lucid_i18n/mixin"))`
  end
end
