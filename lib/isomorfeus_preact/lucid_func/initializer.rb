module LucidFunc
  module Initializer
    def initialize
      self.JS[:native_props] = `{ props: null }`
      @native_props = `Opal.Preact.Props.$new(#{self})`
      @app_store = LucidComponent::AppStoreProxy.new(self)
      @class_store = LucidComponent::ClassStoreProxy.new(self.class.to_s, self, self)
      @store = LucidComponent::InstanceStoreProxy.new(self)
    end
  end
end
