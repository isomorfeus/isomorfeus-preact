module Preact
  module Component
    module NativeComponentConstructor
      # for should_component_update we apply ruby semantics for comparing props
      # to do so, we convert the props to ruby hashes and then compare
      # this makes sure, that for example rubys Nil object gets handled properly
      def self.extended(base)
        component_name = base.to_s
        %x{
          base.preact_component = class extends Opal.global.Preact.Component {
            constructor(props) {
              super(props);
              if (base.$default_state_defined()) {
                this.state = base.$state().$to_n();
              } else {
                this.state = {};
              };
              this.__ruby_instance = base.$new(this);
              var defined_refs = #{base.defined_refs};
              for (var ref in defined_refs) {
                if (defined_refs[ref] != null) {
                  let r = ref; // to ensure cloure for function below gets correct ref name
                  this[ref] = function(element) {
                    element = Opal.Preact.native_element_or_component_to_ruby(element);
                    #{`this.__ruby_instance`.instance_exec(`element`, &`defined_refs[r]`)}
                  }
                  this[ref] = this[ref].bind(this);
                } else {
                  this[ref] = Opal.global.Preact.createRef();
                }
              }
            }
            static get displayName() {
              return #{component_name};
            }
            render(props, state) {
              const oper = Opal.Preact;
              oper.render_buffer.push([]);
              // console.log("preact component pushed", oper.render_buffer, oper.render_buffer.toString());
              oper.active_components.push(this);
              let block_result = #{`this.__ruby_instance`.instance_exec(&`base.render_block`)};
              if (block_result && block_result !== nil) { oper.render_block_result(block_result); }
              // console.log("preact component popping", oper.render_buffer, oper.render_buffer.toString());
              oper.active_components.pop();
              let result = oper.render_buffer.pop();
              return (result.length === 1) ? result[0] : result;
            }
            shouldComponentUpdate(next_props, next_state) {
              if (base.should_component_update_block) {
                return #{!!`this.__ruby_instance`.instance_exec(`Opal.Preact.Props.$new({props: next_props})`, `Opal.Preact.State.$new({state: next_state })`, &`base.should_component_update_block`)};
              }
              if (!Opal.Preact.props_are_equal(this.props, next_props)) { return true; }
              if (Opal.Preact.state_is_not_equal(this.state, next_state)) { return true; }
              return false;
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
