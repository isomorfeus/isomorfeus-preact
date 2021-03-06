module Preact::FunctionComponent::Mixin
  def self.included(base)
    base.include(::Preact::Elements)
    base.include(::Preact::FunctionComponent::Initializer)
    base.include(::Preact::FunctionComponent::Api)
    base.extend(::Preact::FunctionComponent::NativeComponentConstructor)
  end
end
