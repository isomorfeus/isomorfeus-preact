module LucidComponent
  class AppStoreProxy
    def initialize(component_instance)
      if component_instance
        @native = component_instance.to_n
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
        action = { type: 'APPLICATION_STATE', name: (`key.endsWith('=')` ? key.chop : key), value: args[0] }
        Isomorfeus.store.collect_and_defer_dispatch(action)
      else
        # check if we have a component local state value
        if @native && `#@native.props.store`
          if `#@native.props.store.application_state && #@native.props.store.application_state.hasOwnProperty(key)`
            return @native.JS[:props].JS[:store].JS[:application_state].JS[key]
          end
        else
          return AppStore[key]
        end
        # otherwise return nil
        return nil
      end
    end
  end
end
