module Preact::Component::Mixin
  def self.included(base)
    base.include(::Native::Wrapper)
    base.extend(::Preact::Component::NativeComponentConstructor)
    base.extend(::LucidPropDeclaration::Mixin)
    base.include(::Preact::Elements)
    base.include(::Preact::Component::Api)
    base.include(::Preact::Component::Callbacks)
    base.include(::Preact::Component::Initializer)
  end
end
