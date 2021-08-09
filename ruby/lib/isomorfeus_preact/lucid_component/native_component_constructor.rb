module LucidComponent
  module NativeComponentConstructor
    # for should_component_update we apply ruby semantics for comparing props
    # to do so, we convert the props to ruby hashes and then compare
    # this makes sure, that for example rubys Nil object gets handled properly
    def self.extended(base)
      component_name = base.to_s
      wrapper_name = component_name + 'Wrapper'
      %x{
        base.css_styles = null;
        base.preload_block = null;
        base.while_loading_block = null;

        base.preact_component = function(props) {
          let value = Opal.global.PreactHooks.useContext(Opal.global.LucidApplicationContext);
          return Opal.global.Preact.createElement(base.lucid_preact_component, Object.assign({}, props, value));
        };
        base.preact_component.displayName = #{wrapper_name};
        
        base.lucid_preact_component = class extends Opal.global.Preact.Component {
          constructor(props) {
            super(props);
            const oper = Opal.Preact;
            if (base.$default_state_defined()) {
              this.state = base.$state().$to_n();
            } else {
              this.state = {};
            };
            this.__ruby_instance = base.$new(this);
            var defined_refs = base.$defined_refs();
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
            console.log('new instance');
          }
          static get displayName() {
            return #{component_name};
          }
          render(props, state) {
            const oper = Opal.Preact;
            oper.render_buffer.push([]);
            // console.log("lucid component pushed", oper.render_buffer, oper.render_buffer.toString());
            oper.active_components.push(this);
            oper.active_redux_components.push(this);
            let block_result;
            if (base.while_loading_block && !state.preloaded) { block_result = #{`this.__ruby_instance`.instance_exec(&`base.while_loading_block`)}; }
            else { block_result = #{`this.__ruby_instance`.instance_exec(&`base.render_block`)}; }
            if (block_result && block_result !== nil) { oper.render_block_result(block_result); }
            oper.active_redux_components.pop();
            oper.active_components.pop();
            // console.log("lucid component popping", oper.render_buffer, oper.render_buffer.toString());
            let result = oper.render_buffer.pop();
            return (result.length === 1) ? result[0] : result;
          }
          data_access() {
            return this.props.iso_store;
          }
          shouldComponentUpdate(next_props, next_state) {
            if (!Opal.Preact.props_are_equal(this.props, next_props)) { return true; }
            if (Opal.Preact.state_is_not_equal(this.state, next_state)) { return true; }
            return false;
          }
          validateProp(props, propName, componentName) {
            try { base.$validate_prop(propName, props[propName]) }
            catch (e) { return new Error(componentName + " Error: prop validation failed: " + e.message); }
            return null;
          }
        };
      }
    end
  end
end
