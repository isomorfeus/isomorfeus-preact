module Preact
  module FunctionComponent
    module NativeComponentConstructor
      def self.extended(base)
        component_name = base.to_s
        %x{
          base.instance_init = function(initial) {
            let ruby_state = { instance: #{base.new(`{}`)} };
            ruby_state.instance.__ruby_instance = ruby_state.instance;
            return ruby_state;
          }
          base.instance_reducer = function(state, action) { return state; }
          base.preact_component = function(props) {
            const oper = Opal.Preact;
            oper.render_buffer.push([]);
            // console.log("function pushed", oper.render_buffer, oper.render_buffer.toString());
            const [__ruby_state, __ruby_dispatch] = Opal.global.PreactHooks.useReducer(base.instance_reducer, null, base.instance_init);
            const __ruby_instance = __ruby_state.instance;
            __ruby_instance.props = props;
            oper.active_components.push(__ruby_instance);
            let block_result = #{`__ruby_instance`.instance_exec(&`base.render_block`)};
            if (block_result && block_result !== nil) { oper.render_block_result(block_result); }
            oper.active_components.pop();
            // console.log("function popping", oper.render_buffer, oper.render_buffer.toString());
            let result = oper.render_buffer.pop();
            return (result.length === 1) ? result[0] : result;
          }
          base.preact_component.displayName = #{component_name};
        }

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

        def render(&block)
          `base.render_block = #{block}`
        end
      end
    end
  end
end
