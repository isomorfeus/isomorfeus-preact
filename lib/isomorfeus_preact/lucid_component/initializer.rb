module LucidComponent::Initializer
  def initialize(native_component)
    @native = native_component
    @app_store = LucidComponent::AppStoreProxy.new(@native)
    @class_store = LucidComponent::ClassStoreProxy.new(self.class.to_s, @native)
    @props = `Opal.Preact.Props.$new(#@native)`
    @state = `Opal.Preact.State.$new(#@native)`
  end
end
