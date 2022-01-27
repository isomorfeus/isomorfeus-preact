module Preact
  class State
    include ::Native::Wrapper

    def initialize(native)
      @native = native
    end

    def ==(other_state)
      %x{
        if (Opal.Preact.state_is_not_equal(#@native.state, #{other_state.to_raw_n})) { return false; }
        return true;
      }
    end

    def [](key)
      %x{
        if (typeof #@native.state[key] === 'undefined') { return nil; }
        return #@native.state[key];
      }
    end

    def []=(key)
      new_state = `{}`
      new_state.JS[(`key.endsWith('=')` ? key.chop : key)] = args[0]
      @native.JS.setState(new_state, `null`)
    end

    def key?(k)
      %x{
        if (typeof #@native.state[k] !== 'undefined') { return true; }
        return false;
      }
    end

    def method_missing(key, *args, &block)
      if `args.length > 0`
        new_state = `{}`
        new_state.JS[(`key.endsWith('=')` ? key.chop : key)] = args[0]
        if block_given?
          @native.JS.setState(new_state, `function() { block.$call(); }`)
        else
          @native.JS.setState(new_state, `null`)
        end
      else
        %x{
          if (typeof #@native.state[key] === 'undefined') { return nil; }
          return #@native.state[key];
        }
      end
    end

    def set_state(updater, &block)
      new_state = `{}`
      updater.each do |key, value|
        new_state.JS[key] = value
      end
      if block_given?
        @native.JS.setState(new_state, `function() { block.$call(); }`)
      else
        @native.JS.setState(new_state, `null`)
      end
    end

    def size
      `Object.keys(#@native.state).length`;
    end

    def to_n
      %x{
        var new_native = {};
        for (var key in #@native.state) {
          if (typeof #@native.state[key].$to_n !== "undefined") {
            new_native[key] = #@native.state[key].$to_n();
          } else {
            new_native[key] = #@native.state[key];
          }
        }
        return new_native;
      }
    end

    def to_raw_n
      `#@native.state`
    end
  end
end
