module LucidApp
  class Base
    def self.inherited(base)
      base.include(::LucidApp::Mixin)
    end
  end
end
