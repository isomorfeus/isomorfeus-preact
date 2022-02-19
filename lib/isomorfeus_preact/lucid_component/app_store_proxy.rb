module LucidComponent
  class AppStoreProxy
    def initialize(native)
      @native = native
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
        if `#@native?.props?.iso_store?.application_state?.hasOwnProperty?.(key)`
          return `#@native.props.iso_store.application_state[key]`
        else
          return AppStore[key]
        end
        # otherwise return nil
        return nil
      end
    end
  end
end
