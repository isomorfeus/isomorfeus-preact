module React
  module Component
    module NativeComponentConstructor
      # for should_component_update we apply ruby semantics for comparing props
      # to do so, we convert the props to ruby hashes and then compare
      # this makes sure, that for example rubys Nil object gets handled properly
      def self.extended(base)
        component_name = base.to_s
        # language=JS
        %x{
          base.react_component = class extends Opal.global.React.Component {
            constructor(props) {
              super(props);
              if (base.$default_state_defined()) {
                this.state = base.$state().$to_n();
              } else {
                this.state = {};
              };
              if (!base.react_props_declared) {
                let prop_names = base.$declared_props().$keys();
                if (prop_names.length > 0) {
                  if (!base.react_component.propTypes) { base.react_component.propTypes = {}; }
                  for (let i=0;i<prop_names.length;i++) {
                    base.react_component.propTypes[prop_names[i]] = this.validateProp;
                  }
                }
                base.react_props_declared = true;
              }
              this.__ruby_instance = base.$new(this);
              var event_handlers = #{base.event_handlers};
              for (var i = 0; i < event_handlers.length; i++) {
                this[event_handlers[i]] = this[event_handlers[i]].bind(this);
              }
              var defined_refs = #{base.defined_refs};
              for (var ref in defined_refs) {
                if (defined_refs[ref] != null) {
                  this[ref] = function(element) {
                    element = Opal.React.native_element_or_component_to_ruby(element);
                    #{`this.__ruby_instance`.instance_exec(`element`, &`defined_refs[ref]`)}
                  }
                  this[ref] = this[ref].bind(this);
                } else {
                  this[ref] = Opal.global.React.createRef();
                }
              }
            }
            static get displayName() {
              return #{component_name};
            }
            render() {
              Opal.React.render_buffer.push([]);
              Opal.React.active_components.push(this);
              #{`this.__ruby_instance`.instance_exec(&`base.render_block`)};
              Opal.React.active_components.pop();
              return Opal.React.render_buffer.pop();
            }
            shouldComponentUpdate(next_props, next_state) {
              if (base.has_custom_should_component_update) {
                return this.__ruby_instance["$should_component_update"](#{(Hash.new(next_props))}, #{Hash.new(next_state)});
              } else {
                var next_props_keys = Object.keys(next_props);
                var this_props_keys = Object.keys(this.props);
                if (next_props_keys.length !== this_props_keys.length) { return true; }

                var next_state_keys = Object.keys(next_state);
                var this_state_keys = Object.keys(this.state);
                if (next_state_keys.length !== this_state_keys.length) { return true; }

                for (var property in next_props) {
                  if (next_props.hasOwnProperty(property)) {
                    if (!this.props.hasOwnProperty(property)) { return true; };
                    if (property == "children") { if (next_props.children !== this.props.children) { return true; }}
                    else if (typeof next_props[property] !== "undefined" && next_props[property] !== null &&
                             typeof next_props[property]['$!='] !== "undefined" &&
                             typeof this.props[property] !== "undefined" && this.props[property] !== null &&
                             typeof this.props[property]['$!='] !== "undefined") {
                      if (#{ !! (`next_props[property]` != `this.props[property]`) }) { return true; };
                    } else if (next_props[property] !== this.props[property]) { return true; };
                  }
                }
                for (var property in next_state) {
                  if (next_state.hasOwnProperty(property)) {
                    if (!this.state.hasOwnProperty(property)) { return true; };
                    if (next_state[property] !== null && typeof next_state[property]['$!='] !== "undefined" &&
                        this.state[property] !== null && typeof this.state[property]['$!='] !== "undefined") {
                      if (#{ !! (`next_state[property]` != `this.state[property]`) }) { return true };
                    } else if (next_state[property] !== this.state[property]) { return true };
                  }
                }
                return false;
              }
            }
            validateProp(props, propName, componentName) {
              try { base.$validate_prop(propName, props[propName]) }
              catch (e) { return new Error(componentName + " Error: prop validation failed: " + e.message); }
              return null;
            }
          }
        }
      end
    end
  end
end
