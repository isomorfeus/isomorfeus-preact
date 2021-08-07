module LucidComponent
  class ClassStoreProxy
    def initialize(component_name, component_instance = nil, native = nil)
      @component_name = component_name
      if component_instance
        @native = native
        @component_instance = component_instance
      end
    end

    def [](key)
      method_missing(key)
    end

    def []=(key, value)
      method_missing(key, value)
    end

    def method_missing(key, *args, &block)
      if `args.length > 0`
        # set class state, simply a dispatch
        action = { type: 'CLASS_STATE', class: @component_name, name: (`key.endsWith('=')` ? key.chop : key), value: args[0] }
        Isomorfeus.store.collect_and_defer_dispatch(action)
      else
        # get class state
        # check if we have a component local state value
        if @native && @native.JS[:props].JS[:store]
          if @native.JS[:props].JS[:store].JS[:class_state] &&
              @native.JS[:props].JS[:store].JS[:class_state].JS[@component_name] &&
              @native.JS[:props].JS[:store].JS[:class_state].JS[@component_name].JS.hasOwnProperty(key)
            return @native.JS[:props].JS[:store].JS[:class_state].JS[@component_name].JS[key]
          end
        else
          a_state = Isomorfeus.store.get_state
          if a_state.key?(:class_state) && a_state[:class_state].key?(@component_name) && a_state[:class_state][@component_name].key?(key)
            return a_state[:class_state][@component_name][key]
          end
        end
        # otherwise return nil
        return nil
      end
    end
  end
end
