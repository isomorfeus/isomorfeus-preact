module LucidComponent
  module Initializer
    def initialize(native_component)
      @native = native_component
      @app_store = LucidComponent::AppStoreProxy.new(self)
      @class_store = LucidComponent::ClassStoreProxy.new(self.class.to_s, self, @native)
      # @iso_store = Isomorfeus::IsomorphicStoreProxy.new(self)
      # @local_store = Isomorfeus::LocalStoreProxy.new(self)
      @store = LucidComponent::InstanceStoreProxy.new(self)
      @props = `Opal.Preact.Component.Props.$new(#@native)`
      @state = `Opal.Preact.Component.State.$new(#@native)`
    end
  end
end
