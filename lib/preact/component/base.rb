module Preact::Component
  class Base
    def self.inherited(base)
      base.include(::Preact::Component::Mixin)
    end
  end
end
