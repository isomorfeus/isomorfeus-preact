module LucidApp
  module Mixin
    def self.included(base)
      base.include(::Native::Wrapper)
      base.extend(::LucidApp::NativeComponentConstructor)
      base.extend(::React::Component::NativeComponentValidateProp)
      base.extend(::React::Component::ShouldComponentUpdate)
      base.extend(::React::Component::EventHandler)
      base.include(::React::Component::Elements)
      base.include(::React::Component::API)
      base.include(::React::Component::Callbacks)
      base.include(::React::ReduxComponent::API)
      base.include(::LucidApp::API)
      base.include(::React::Component::Features)
      base.include(::React::Component::Resolution)
    end
  end
end
