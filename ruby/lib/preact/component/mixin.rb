module Preact
  module Component
    module Mixin
      def self.included(base)
        base.include(::Native::Wrapper)
        base.extend(::Preact::Component::NativeComponentConstructor)
        base.extend(::LucidPropDeclaration::Mixin)
        if on_browser? || on_ssr?
          base.include(::Preact::Component::Elements)
        elsif on_mobile?
          base.include(::ReactNative::Component::Elements)
        end
        base.include(::Preact::Component::Api)
        base.include(::Preact::Component::Callbacks)
        base.include(::Preact::Component::Initializer)
        base.include(::Preact::Component::Features)
      end
    end
  end
end
