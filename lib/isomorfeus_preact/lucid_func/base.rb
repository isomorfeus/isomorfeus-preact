module LucidFunc
  class Base
    def self.inherited(base)
      base.include(::LucidFunc::Mixin)
    end
  end
end
