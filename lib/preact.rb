module Preact
  %x{
    self.render_buffer = [];

    self.set_validate_prop = function(component, prop_name) {
      let core = component.preact_component;
      if (typeof core.propTypes == "undefined") {
        core.propTypes = {};
        core.propValidations = {};
        core.propValidations[prop_name] = {};
      }
      core.propTypes[prop_name] = core.prototype.validateProp;
    };

    self.props_are_equal = function(this_props, next_props) {
      let counter = 0;
      for (var property in next_props) {
        counter++;
        if (next_props.hasOwnProperty(property)) {
          if (!this_props.hasOwnProperty(property)) { return false; };
          if (property === "children") { if (next_props.children !== this_props.children) { return false; }}
          else if (typeof next_props[property] === "object" && next_props[property] !== null && typeof next_props[property]['$!='] === "function" &&
                   typeof this_props[property] !== "undefined" && this_props[property] !== null ) {
            if (#{ !! (`next_props[property]` != `this_props[property]`) }) { return false; }
          } else if (next_props[property] !== this_props[property]) { return false; }
        }
      }
      if (counter !== Object.keys(this_props).length) { return false; }
      return true;
    };

    self.state_is_not_equal = function(this_state, next_state) {
      let counter = 0;
      for (var property in next_state) {
        counter++;
        if (next_state.hasOwnProperty(property)) {
          if (!this_state.hasOwnProperty(property)) { return true; };
          if (typeof next_state[property] === "object" && next_state[property] !== null && typeof next_state[property]['$!='] === "function" &&
              typeof this_state[property] !== "undefined" && this_state[property] !== null) {
            if (#{ !! (`next_state[property]` != `this_state[property]`) }) { return true }
          } else if (next_state[property] !== this_state[property]) { return true }
        }
      }
      if (counter !== Object.keys(this_state).length) { return true; }
      return false;
    };

    self.lower_camelize = function(snake_cased_word) {
      if (self.prop_dictionary[snake_cased_word]) { return self.prop_dictionary[snake_cased_word]; }
      let parts = snake_cased_word.split('_');
      let res = parts[0];
      for (let i = 1; i < parts.length; i++) {
        res += parts[i][0].toUpperCase() + parts[i].slice(1);
      }
      self.prop_dictionary[snake_cased_word] = res;
      return res;
    };

    self.native_element_or_component_to_ruby = function (element) {
      if (typeof element.__ruby_instance !== 'undefined') { return element.__ruby_instance }
      if (element instanceof Element || element instanceof Node) { return #{Browser::Element.new(`element`)} }
      return element;
    };

    self.native_to_ruby_event = function(event) {
       if ('target' in event) { return #{::Browser::Event.new(`event`)}; }
       else if (Array.isArray(event)) { return event; }
       else { return Opal.Hash.$new(event); }
    };

    self.internal_prepare_args_and_render = function(component, args, block) {
      const operain = self.internal_render;
      if (args.length > 0) {
        let last_arg = args[args.length - 1];
        if (last_arg && last_arg.constructor === String) {
          if (args.length === 1) { return operain(component, null, last_arg, null); }
          else { operain(component, args[0], last_arg, null); }
        } else { operain(component, args[0], null, block); }
      } else { operain(component, null, null, block); }
    };

    self.active_components = [];

    self.active_component = function() {
      let length = self.active_components.length;
      if (length === 0) { return null; };
      return self.active_components[length-1];
    };

    self.active_redux_components = [];

    self.active_redux_component = function() {
      let length = self.active_redux_components.length;
      if (length === 0) { return null; };
      return self.active_redux_components[length-1];
    };

    function isObject(obj) { return (obj && typeof obj === 'object'); }

    self.merge_deep = function(one, two) {
      return [one, two].reduce(function(pre, obj) {
        Object.keys(obj).forEach(function(key){
          let pVal = pre[key];
          let oVal = obj[key];
          if (Array.isArray(pVal) && Array.isArray(oVal)) {
            pre[key] = pVal.concat.apply(this, oVal);
          } else if (isObject(pVal) && isObject(oVal)) {
            pre[key] = self.merge_deep(pVal, oVal);
          } else {
            pre[key] = oVal;
          }
        });
        return pre;
      }, {});
    };

    self.prop_dictionary = {};

    self.to_native_preact_props = function(ruby_style_props) {
      let result = {};
      let keys = ruby_style_props.$$keys;
      let keys_length = keys.length;
      let key = '';
      for (let i = 0; i < keys_length; i++) {
        key = keys[i];
        let value = ruby_style_props.$$smap[key];
        if (key[0] === 'o' && key[1] === 'n' && key[2] === '_') {
          let type = typeof value;
          if (type === "function") {
            let active_c = self.active_component();
            result[self.lower_camelize(key)] = function(event, info) {
              let ruby_event = self.native_to_ruby_event(event);
              #{`active_c.__ruby_instance`.instance_exec(`ruby_event`, `info`, &`value`)};
            }
          } else if (type === "object" && typeof value.m === "object" && typeof value.m.$call === "function" ) {
            if (!value.preact_event_handler_function) {
              value.preact_event_handler_function = function(event, info) {
                let ruby_event = self.native_to_ruby_event(event);
                if (value.a.length > 0) { value.m.$call.apply(value.m, [ruby_event, info].concat(value.a)); }
                else { value.m.$call(ruby_event, info); }
              };
            }
            result[self.lower_camelize(key)] = value.preact_event_handler_function;
          } else if (type === "string" ) {
            let active_component = self.active_component();
            let method_ref;
            let method_name = '$' + value;
            if (typeof active_component[method_name] === "function") {
              // got a ruby instance
              if (active_component.native && active_component.native.method_refs && active_component.native.method_refs[value]) { method_ref = active_component.native.method_refs[value]; } // ruby instance with native
              else if (active_component.method_refs && active_component.method_refs[value]) { method_ref = active_component.method_refs[value]; } // ruby function component
              else { method_ref = active_component.$method_ref(value); } // create the ref
            } else if (typeof active_component.__ruby_instance[method_name] === "function") {
              // got a native instance
              if (active_component.method_refs && active_component.method_refs[value]) { method_ref = active_component.method_refs[value]; }
              else { method_ref = active_component.__ruby_instance.$method_ref(value); } // create ref for native
            }
            if (method_ref) {
              if (!method_ref.preact_event_handler_function) {
                method_ref.preact_event_handler_function = function(event, info) {
                  let ruby_event = self.native_to_ruby_event(event);
                  method_ref.m.$call(ruby_event, info)
                };
              }
              result[self.lower_camelize(key)] = method_ref.preact_event_handler_function;
            } else {
              let component_name;
              if (active_component.__ruby_instance) { component_name = active_component.__ruby_instance.$to_s(); }
              else { component_name = active_component.$to_s(); }
              #{Isomorfeus.raise_error(message: "Is #{`value`} a valid method of #{`component_name`}? If so then please use: #{`key`}: method_ref(:#{`value`}) within component: #{`component_name`}")}
            }
          } else {
            let active_component = self.active_component();
            let component_name;
            if (active_component.__ruby_instance) { component_name = active_component.__ruby_instance.$to_s(); }
            else { component_name = active_component.$to_s(); }
            #{Isomorfeus.raise_error(message: "Received invalid value for #{`key`} with #{`value`} within component: #{`component_name`}")}
            console.error( + key + " event handler:", value, " within component:", self.active_component());
          }
        } else if (key[0] === 'a' && key.startsWith("aria_")) {
          result[key.replace("_", "-")] = value;
        } else if (key === "style" || key === "theme") {
          if (typeof value.$to_n === "function") { value = value.$to_n() }
          result[key] = value;
        } else {
          result[self.lower_camelize(key)] = value;
        }
      }
      return result;
    };

    self.render_block_result = function(block_result) {
      if (block_result.constructor === String || block_result.constructor === Number) {
        Opal.Preact.render_buffer[Opal.Preact.render_buffer.length - 1].push(block_result);
      }
    };

    self.internal_render = function(component, props, string_child, block) {
      const operabu = self.render_buffer;
      let native_props;
      if (props && props !== nil) { native_props = self.to_native_preact_props(props); }
      if (string_child) {
        operabu[operabu.length - 1].push(Opal.global.Preact.createElement(component, native_props, string_child));
      } else if (block && block !== nil) {
        operabu.push([]);
        // console.log("internal_render pushed", Opal.Preact.render_buffer, Opal.Preact.render_buffer.toString());
        let block_result = block.$call();
        if (block_result && block_result !== nil) { Opal.Preact.render_block_result(block_result); }
        // console.log("internal_render popping", Opal.Preact.render_buffer, Opal.Preact.render_buffer.toString());
        let children = operabu.pop();
        operabu[operabu.length - 1].push(Opal.global.Preact.createElement.apply(this, [component, native_props].concat(children)));
      } else {
        operabu[operabu.length - 1].push(Opal.global.Preact.createElement(component, native_props));
      }
    };

    self.deep_force_update = function(component) {
      if (component.forceUpdate) { component.forceUpdate(); }
      if (component.__c) { self.deep_force_update(component.__c); }
      else if (component.base) { self.update_components_from_dom(component.base); }
    };

    self.update_components_from_dom = function(node, fn) {
      let children = node.childNodes;
      for (let i=children && children.length; i--;) {
        let child = children[i];
        if (child.__c) { self.deep_force_update(child.__c); }
        else { self.update_components_from_dom(child, fn); }
      }
    };
  }


  def self.create_element(type, props = nil, children = nil, &block)
    %x{
      const operabu = self.render_buffer;
      let component = null;
      let native_props = null;
      if (typeof type.preact_component !== 'undefined') { component = type.preact_component; }
      else { component = type; }
      if (block !== nil) {
        operabu.push([]);
        // console.log("create_element pushed", Opal.Preact.render_buffer, Opal.Preact.render_buffer.toString());
        let block_result = block.$call();
        if (block_result && block_result !== nil) { Opal.Preact.render_block_result(block_result); }
        // console.log("create_element popping", Opal.Preact.render_buffer, Opal.Preact.render_buffer.toString());
        children = operabu.pop();
      } else if (children === nil) { children = []; }
      else if (typeof children === 'string') { children = [children]; }
      if (props && props !== nil) { native_props = self.to_native_preact_props(props); }
      return Opal.global.Preact.createElement.apply(this, [component, native_props].concat(children));
    }
  end

  def self.to_child_array(props_children)
    `Opal.global.Preact.toChildArray(children)`
  end

  def self.clone_element(ruby_preact_element, props = nil, children = nil, &block)
    block_result = `null`
    if block_given?
      block_result = block.call
      block_result = `null` unless block_result
    end
    native_props = props ? `Opal.Preact.to_native_preact_props(props)` : `null`
    `Opal.global.Preact.cloneElement(ruby_preact_element.$to_n(), native_props, block_result)`
  end

  def self.create_context(const_name, default_value)
    %x{
      Opal.global[const_name] = Opal.global.Preact.createContext(default_value);
      var new_const = #{Preact::ContextWrapper.new(`Opal.global[const_name]`)};
      #{Object.const_set(const_name, `new_const`)};
      return new_const;
    }
  end

  def self.create_ref
    Preact::Ref.new(`Opal.global.Preact.createRef()`)
  end

  def self.hydrate(native_preact_element, container_node, replace_node)
    `Opal.global.Preact.hydrate(native_preact_element, container_node)`
  end

  def self.location_hook(location)
    %x{
      if (Opal.global.locationHook) { return Opal.global.locationHook; }
      else if (Opal.global.staticLocationHook) { return Opal.global.staticLocationHook(location); }
      else { #{raise "Wouter Location Hooks not imported!"}; }
    }
  end

  def self.render(native_preact_element, container_node, replace_node)
    # container is a native DOM element
    if block_given?
      `Opal.global.Preact.render(native_preact_element, container_node, function() { block.$call() })`
    else
      `Opal.global.Preact.render(native_preact_element, container_node)`
    end
  end

  if on_ssr?
    def self.render_to_string(native_preact_element)
      `Opal.global.Preact.renderToString(native_preact_element)`
    end
  end

  def self.unmount_component_at_node(element_or_query)
    if `(typeof element_or_query === 'string')` || (`(typeof element_or_query.$class === 'function')` && element_or_query.class == String)
      element = `document.body.querySelector(element_or_query)`
    elsif `(typeof element_or_query.$is_a === 'function')` && element_or_query.is_a?(Browser::Element)
      element = element_or_query.to_n
    else
      element = element_or_query
    end
    `Opal.global.Preact.render(null, element)`
  end
end
