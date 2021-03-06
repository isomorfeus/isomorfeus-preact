module Preact::Component::Api
  def self.included(base)
    base.instance_exec do
      base_module = base.to_s.deconstantize
      if base_module != ''
        base_module.constantize.define_singleton_method(base.to_s.demodulize) do |*args, &block|
          `Opal.Preact.internal_prepare_args_and_render(#{base}.preact_component, args, block)`
        end
      else
        Object.define_method(base.to_s) do |*args, &block|
          `Opal.Preact.internal_prepare_args_and_render(#{base}.preact_component, args, block)`
        end
      end

      attr_accessor :props
      attr_accessor :state

      def ref(ref_name, &block)
        defined_refs.JS[ref_name] = block_given? ? block : `null`
      end

      def defined_refs
        @defined_refs ||= `{}`
      end

      def default_state_defined
        @default_state_defined
      end

      def state
        return @default_state if @default_state
        @default_state_defined = true
        %x{
          var native_state = {state: {}};
          native_state.setState = function(new_state, callback) {
            for (var key in new_state) {
              this.state[key] = new_state[key];
            }
            if (callback) { callback.call(); }
          }
        }
        @default_state = `Opal.Preact.State.$new(native_state)`
      end

      def render(&block)
        `base.render_block = #{block}`
      end

      def should_component_update?(&block)
        `base.should_component_update_block = block`
      end

      def to_js
        self.JS[:preact_component]
      end
    end
  end

  def display_name
    @native.JS[:displayName]
  end

  def force_update(&block)
    if block_given?
      # this maybe needs instance_exec too
      @native.JS.forceUpdate(`function() { block.$call(); }`)
    else
      @native.JS.forceUpdate
    end
  end

  def get_preact_element(arg, &block)
    `const operabu = Opal.Preact.render_buffer`
    if block_given?
      # execute block, fetch last element from buffer
      %x{
        let last_buffer_length = operabu[operabu.length - 1].length;
        let last_buffer_element = operabu[operabu.length - 1][last_buffer_length - 1];
        block.$call();
        // console.log("get_preact_element popping", operabu, operabu.toString())
        let new_element = operabu[operabu.length - 1].pop();
        if (last_buffer_element === new_element) { #{Isomorfeus.raise_error(message: "Block did not create any Preact element!")} }
        return new_element;
      }
    else
      # element was rendered before being passed as arg
      # fetch last element from buffer
      # `console.log("get_preact_element popping", operabu, operabu.toString())`
      `operabu[operabu.length - 1].pop()`
    end
  end
  alias gpe get_preact_element

  def history
    Isomorfeus.browser_history
  end

  def method_ref(method_symbol, *args)
    method_key = "#{method_symbol}#{args}"
    %x{
      if (#@native.method_refs?.[#{method_key}]) { return #@native.method_refs[#{method_key}]; }
      if (!#@native.method_refs) { #@native.method_refs = {}; }
      #@native.method_refs[#{method_key}] = { m: null, a: args };
      let r = #@native.method_refs[#{method_key}];
      let dev = #{Isomorfeus.development?};
      r.preact_event_handler_function = function(event, info) {
        let ruby_event = Opal.Preact.native_to_ruby_event(event);
        if (!r.m || dev) { r.m = #{method(method_symbol)} };
        if (r.a.length > 0) { r.m.$call.apply(r.m, [ruby_event, info].concat(r.a)); }
        else { r.m.$call(ruby_event, info); }
      };
      return #@native.method_refs[#{method_key}];
    }
  end
  alias m_ref method_ref

  def render_preact_element(el)
    # push el to buffer
    `Opal.Preact.render_buffer[Opal.Preact.render_buffer.length - 1].push(el)`
    # `console.log("render_preact_element pushed", Opal.Preact.render_buffer, Opal.Preact.render_buffer.toString())`
    nil
  end
  alias rpe render_preact_element

  def ref(name)
    `#@native[name]`
  end

  def ruby_ref(name)
    return `#@native[name]` if `(typeof #@native[name] === 'function')`
    `Opal.Preact.Ref.$new(#@native[name])`
  end

  def set_state(updater, &callback)
    @state.set_state(updater, &callback)
  end
end
