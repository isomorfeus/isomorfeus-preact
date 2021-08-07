module LucidApp
  module NativeLucidComponentConstructor
    # for should_component_update we apply ruby semantics for comparing props
    # to do so, we convert the props to ruby hashes and then compare
    # this makes sure, that for example rubys Nil object gets handled properly
    def self.extended(base)
      component_name = base.to_s
      %x{
        base.lucid_preact_component = class extends Opal.global.Preact.Component {
          constructor(props) {
            super(props);
            const oper = Opal.Preact;
            if (base.$default_state_defined()) {
              this.state = base.$state().$to_n();
            } else {
              this.state = {};
            };
            this.state.isomorfeus_store_state = Opal.Isomorfeus.store.native.getState();
            var current_store_state = this.state.isomorfeus_store_state;
            if (typeof current_store_state.class_state[#{component_name}] !== "undefined") {
              this.state.class_state = {};
              this.state.class_state[#{component_name}] = current_store_state.class_state[#{component_name}];
            } else {
              this.state.class_state = {};
              this.state.class_state[#{component_name}] = {};
            };
            this.__ruby_instance = base.$new(this);
            var defined_refs = #{base.defined_refs};
            for (var ref in defined_refs) {
              if (defined_refs[ref] != null) {
                this[ref] = function(element) {
                  element = oper.native_element_or_component_to_ruby(element);
                  #{`this.__ruby_instance`.instance_exec(`element`, &`defined_refs[ref]`)}
                }
                this[ref] = this[ref].bind(this);
              } else {
                this[ref] = Opal.global.Preact.createRef();
              }
            }
            if (base.preload_block) {
              oper.active_redux_components.push(this);
              this.state.preloaded = this.__ruby_instance.$execute_preload_block();
              oper.active_redux_components.pop();
            }
            this.listener = this.listener.bind(this);
            this.unsubscriber = Opal.Isomorfeus.store.native.subscribe(this.listener);
          }
          static get displayName() {
            return #{component_name};
          }
          static set displayName(new_name) {
            // dont do anything here except returning the set value
            return new_name;
          }
          render(props, state) {
            const oper = Opal.Preact;
            oper.render_buffer.push([]);
            // console.log("lucid app pushed", oper.render_buffer, oper.render_buffer.toString());
            oper.active_components.push(this);
            oper.active_redux_components.push(this);
            let block_result;
            if (base.while_loading_block && !state.preloaded) { block_result = #{`this.__ruby_instance`.instance_exec(&`base.while_loading_block`)}; }
            else { block_result = #{`this.__ruby_instance`.instance_exec(&`base.render_block`)}; }
            if (block_result && block_result !== nil) { oper.render_block_result(block_result); }
            oper.active_redux_components.pop();
            oper.active_components.pop();
            let children = oper.render_buffer.pop();
            // console.log("lucid app popping", oper.render_buffer, oper.render_buffer.toString());
            return Opal.global.Preact.createElement.apply(this, [Opal.global.LucidApplicationContext.Provider, { value: this.state.isomorfeus_store_state }].concat(children));
          }
          data_access() {
            this.state.isomorfeus_store_state;
          }
          listener() {
            let next_state = Opal.Isomorfeus.store.native.getState();
            this.setState({ isomorfeus_store_state: next_state });
          }
          componentWillUnmount() {
            if (typeof this.unsubscriber === "function") { this.unsubscriber(); }
          }
          validateProp(props, propName, componentName) {
            try { base.$validate_prop(propName, props[propName]) }
            catch (e) { return new Error(componentName + ": Error: prop validation failed: " + e.message); }
            return null;
          }
        }
        base.preload_block = null;
        base.while_loading_block = null;
        base.jss_styles = null;
        base.use_styles = null;
      }
    end
  end
end
