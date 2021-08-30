module LucidComponent
  class Base
    def self.inherited(base)
      base.include(::LucidComponent::Mixin)
    end
  end
end
