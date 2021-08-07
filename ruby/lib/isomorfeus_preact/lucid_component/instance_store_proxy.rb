module LucidComponent
  class InstanceStoreProxy
    def initialize(component_instance)
      @native = component_instance.to_n
      @component_instance = component_instance
      @component_object_id = component_instance.object_id.to_s
    end

    def [](key)
      method_missing(key)
    end

    def []=(key, value)
      method_missing(key, value)
    end

    def method_missing(key, *args, &block)
      if `args.length > 0`
        # set instance state, simply a dispatch

        action = { type: 'INSTANCE_STATE', object_id: @component_object_id, name: (`key.endsWith('=')` ? key.chop : key), value: args[0] }
        Isomorfeus.store.collect_and_defer_dispatch(action)

      else
        # get instance state
        if @native.JS[:props].JS[:store]
          if @native.JS[:props].JS[:store].JS[:instance_state] &&
              @native.JS[:props].JS[:store].JS[:instance_state].JS[@component_object_id] &&
              @native.JS[:props].JS[:store].JS[:instance_state].JS[@component_object_id].JS.hasOwnProperty(key)
            # check if we have a component local state value
            return @native.JS[:props].JS[:store].JS[:instance_state].JS[@component_object_id].JS[key]
          end
        else
          a_state = Isomorfeus.store.get_state
          if a_state.key?(:instance_state) && a_state[:instance_state].key?(key)
            return a_state[:instance_state][key]
          end
        end
        # otherwise return nil
        return nil
      end
    end
  end
end
