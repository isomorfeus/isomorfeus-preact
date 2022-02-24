module Browser
  class History
    include Native::Wrapper

    alias_native :back
    alias_native :forward
    alias_native :go

    native_reader :length
    alias :size :length

    def push_state(state, title = '', url = `null`)
      `#@native.pushState(#{state.to_n}, #{title}, #{url})`
    end

    def replace_state(state, title = '', url = `null`)
      `#@native.replaceState(#{state.to_n}, #{title}, #{url})`
    end

    def scroll_restoration
      `#@native.scrollRestoration`
    end

    def scroll_restoration=(s)
      `#@native.scrollRestoration = #{s}`
    end

    def state
      ::Hash.new(`#@native.state`)
    end
  end
end
