module Preact::FunctionComponent::Api
  def props
    @native_props
  end

  def use_callback(*deps, &block)
    `Opal.global.PreactHooks.useCallback(function() { #{block.call} }, deps)`
  end

  def use_context(context)
    native_context = `(typeof context.$is_wrapped_context !== 'undefined')` ? context.to_n : context
    `Opal.global.PreactHooks.useContext(native_context)`
  end

  def use_debug_value(value, formatter)
    formatter = `null` unless formatter
    `Opal.global.PreactHooks.useDebugValue(value, formatter)`
  end

  def use_effect(*args, &block)
    `Opal.global.PreactHooks.useEffect(function() { #{block.call} }, args)`
  end

  def use_error_boundary(&block)
    error = nil
    reset_error = nil
    %x{
      let _error;
      let _reset_error;
      if (block) {
        [_error, reset_error] = Opal.global.PreactHooks.useErrorBoundary(function() { #{block.call(Error(_error))} });
      } else {
        [_error, reset_error] = Opal.global.PreactHooks.useErrorBoundary();
      }
      error = #{Error(e)};
    }
    [error, reset_error]
  end

  def use_imperative_handle(ruby_ref, *args, &block)
    ref = ruby_ref.to_n
    args = `null` if args.empty?
    `Opal.global.PreactHooks.useImperativeHandle(ref, function() { #{block.call} }, args)`
  end

  def use_layout_effect(&block)
    `Opal.global.PreactHooks.useLayoutEffect(function() { #{block.call} })`
  end

  def use_memo(*deps, &block)
    `Opal.global.PreactHooks.useMemo(function() { #{block.call} }, deps)`
  end

  def use_reducer(inital_state, &block)
    state = nil
    dispatcher = nil
    %x{
      [state, dispatcher] = Opal.global.PreactHooks.useReducer(function(state, action) {
        #{block.call(state, action)}
      }, initial_state);
    }
    [state, proc { |arg| `dispatcher(arg)` }]
  end

  def use_ref(native_ref)
    Preact::Ref.new(`Opal.global.PreactHooks.useRef(native_ref)`)
  end

  def use_state(initial_value)
    initial = nil
    setter = nil
    `[initial, setter] = Opal.global.PreactHooks.useState(initial_value);`
    [initial, proc { |arg| `setter(arg)` }]
  end

  def get_preact_element(arg, &block)
    `let operabu = Opal.Preact.render_buffer`
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

  def render_preact_element(el)
    # push el to buffer
    `Opal.Preact.render_buffer[Opal.Preact.render_buffer.length - 1].push(el)`
    # `console.log("render_preact_element pushed", Opal.Preact.render_buffer, Opal.Preact.render_buffer.toString())`
    nil
  end
  alias rpe render_preact_element

  def method_ref(method_symbol, *args)
    method_key = "#{method_symbol}#{args}"
    %x{
      if (#{self}.method_refs?.[#{method_key}]) { return #{self}.method_refs[#{method_key}]; }
      if (!#{self}.method_refs) { #{self}.method_refs = {}; }
      #{self}.method_refs[#{method_key}] = { m: #{method(method_symbol)}, a: args };
      return #{self}.method_refs[#{method_key}];
    }
  end
  alias m_ref method_ref

  def to_n
    self
  end
end
