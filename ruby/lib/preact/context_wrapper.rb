module Preact
  class ContextWrapper
    include ::Native::Wrapper

    def initialize(native)
      @native = native
    end
    
    def is_wrapped_context
      true
    end

    def Consumer(*args, &block)
      %x{
        let operabu = Opal.Preact.render_buffer;
        let props = null;

        if (args.length > 0) { props = Opal.Preact.to_native_preact_props(args[0]); }

        let preact_element = Opal.global.Preact.createElement(this.native.Consumer, props, function(value) {
          let children = null;
          if (block !== nil) {
            operabu.push([]);
            // console.log("consumer pushed", operabu, operabu.toString());
            let block_result = block.$call(value);
            if (block_result && block_result !== nil) { Opal.Preact.render_block_result(block_result); }
            // console.log("consumer popping", operabu, operabu.toString());
            children = operabu.pop();
            if (children.length === 1) { children = children[0]; }
            else if (children.length === 0) { children = null; }
          }
          return children;
        });
        operabu[operabu.length - 1].push(preact_element);
      }
    end

    def Provider(*args, &block)
      %x{
        var props = null;
        if (args.length > 0) { props = Opal.Preact.to_native_preact_props(args[0]); }
        Opal.Preact.internal_render(this.native.Provider, props, null, block);
      }
    end
  end
end
