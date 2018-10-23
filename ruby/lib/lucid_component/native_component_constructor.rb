module LucidComponent
  module NativeComponentConstructor
    # for should_component_update we apply ruby semantics for comparing props
    # to do so, we convert the props to ruby hashes and then compare
    # this makes sure, that for example rubys Nil object gets handled properly
    def self.extended(base)
      component_name = base.to_s
      # language=JS
      %x{
        base.react_component = function(props) {
          return React.createElement(LucidApplicationContext.Consumer, null, function(store) {
            var store_props = Object.assign({}, props, { isomorfeus_store: store });
            return React.createElement(base.lucid_react_component, store_props);
          });
        }
        base.lucid_react_component = class extends React.Component {
          constructor(props) {
            super(props);
            if (base.$state().$size() > 0) {
              this.state = base.$state().$to_n();
            } else {
              this.state = {};
            };
            this.__ruby_instance = base.$new(this);
            this.__object_id = this.__ruby_instance.$object_id().$to_s();
            if (!this.state.component_state) {
              this.state.component_state = {};
              this.state.component_state[this.__object_id] = {};
            };
            var event_handlers = #{base.event_handlers};
            for (var i = 0; i < event_handlers.length; i++) {
              this[event_handlers[i]] = this[event_handlers[i]].bind(this);
            }
            var defined_refs = #{base.defined_refs};
            for (var ref in defined_refs) {
              if (defined_refs[ref] != null) {
                this[ref] = function(element) {
                  #{`this.__ruby_instance`.instance_exec(React::Ref.new(`element`), `defined_refs[ref]`)}
                }
                this[ref] = this[ref].bind(this);
              } else {
                this[ref] = React.createRef();
              }
            }
          }
          data_access() {
            return this.props.isomorfeus_store
          }
          static get displayName() {
            return #{component_name};
          }
          shouldComponentUpdate(next_props, next_state) {
            var next_props_keys = Object.keys(next_props);
            var this_props_keys = Object.keys(this.props);
            if (next_props_keys.length !== this_props_keys.length) { return true; }

            var next_state_keys = Object.keys(next_state);
            var this_state_keys = Object.keys(this.state);
            if (next_state_keys.length !== this_state_keys.length) { return true; }

            for (var property in next_props) {
              if (property === "isomorfeus_store") {
                var res = this.scu_for_used_store_keys(this.state.isomorfeus_store, next_state.isomorfeus_store);
                if (res) { return true; }
              }
              if (next_props.hasOwnProperty(property)) {
                if (!this.props.hasOwnProperty(property)) { return true; };
                if (property == "children") { if (next_props.children !== this.props.children) { return true; }}
                else if (typeof next_props[property] !== "undefined" && typeof next_props[property]['$!='] !== "undefined" && typeof this.props[property] !== "undefined" && typeof this.props[property]['$!='] !== "undefined") {
                  if (#{ !! (`next_props[property]` != `this.props[property]`) }) { return true; };
                } else if (next_props[property] !== this.props[property]) { return true; };
              }
            }
            for (var property in next_state) {
              if (next_state.hasOwnProperty(property)) {
                if (!this.state.hasOwnProperty(property)) { return true; };
                if (typeof next_state[property]['$!='] !== "undefined" && typeof this.state[property]['$!='] !== "undefined") {
                  if (#{ !! (`next_state[property]` != `this.state[property]`) }) { return true };
                } else if (next_state[property] !== this.state[property]) { return true };
              }
            }
            return false;
          }
          scu_for_used_store_keys(current_state, next_state) {
            var unique_used_store_keys = this.used_store_keys.filter(function(elem, pos) {
              return (this.used_store_keys.indexOf(elem) === pos);
            });
            var used_length = unique_used_store_keys.length;
            var store_key;
            var current_value;
            var next_value;
            for (var i = 0; i < used_length; i++) {
              store_key = unique_used_store_keys[i];
              current_value = store_key.reduce(function(prev, curr) { prev && prev[curr] }, current_state);
              next_value = store_key.reduce(function(prev, curr) { prev && prev[curr] }, next_state);
              if (current_value !== next_value) { return true; };
            }
            return false;
          }
          validateProp(props, propName, componentName) {
            if (propName === "isomorfeus_store") { return null };
            var prop_data = base.lucid_react_component.propValidations[propName];
            if (!prop_data) { return true; };
            var value = props[propName];
            var result;
            if (typeof prop_data.ruby_class != "undefined") {
              result = (value.$class() == prop_data.ruby_class);
              if (!result) {
                return new Error('Invalid prop ' + propName + '! Expected ' + prop_data.ruby_class.$to_s() + ' but was ' + value.$class().$to_s() + '!');
              }
            } else if (typeof prop_data.is_a != "undefined") {
              result = value["$is_a?"](prop_data.is_a);
              if (!result) {
                return new Error('Invalid prop ' + propName + '! Expected a child of ' + prop_data.is_a.$to_s() + '!');
              }
            }
            if (typeof prop_data.required != "undefined") {
              if (prop_data.required && (typeof props[propName] == "undefined")) {
                return new Error('Prop ' + propName + ' is required but not given!');
              }
            }
            return null;
          }
        }
      }
    end
  end
end
