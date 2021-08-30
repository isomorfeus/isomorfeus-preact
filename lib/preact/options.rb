module Preact
  class Options
    class << self
      def debounce_rendering(&block)
        %x{
          const old_hook = Opal.global.Preact.options.debounceRendering;
          Opal.global.Preact.options.debounceRendering = function(callback) {
            #{block.call};
            if (old_hook) {
              old_hook(callback);
            }
          }
        }
        nil
      end

      def diffed(&block)
        # TODO wrap vnode
        %x{
          const old_hook = Opal.global.Preact.options.diffed;
          Opal.global.Preact.options.diffed = function(vnode) {
            #{block.call(`vnode`)};
            if (old_hook) {
              old_hook(vnode);
            }
          }
        }
        nil
      end

      def event(&block)
        %x{
          const old_hook = Opal.global.Preact.options.event;
          Opal.global.Preact.options.event = function(event) {
            ruby_event = #{Browser::Event.new(`event`)}
            ruby_event = #{block.call(`ruby_event`)};
            return ruby_event.native;
          }
        }
        nil
      end

      def request_animation_frame(&block)
        %x{
          const old_hook = Opal.global.Preact.options.requestAnimationFrame;
          Opal.global.Preact.options.requestAnimationFrame = function(callback) {
            #{block.call};
            if (old_hook) {
              old_hook(callback);
            }
          }
        }
        nil
      end

      def unmount(&block)
        # TODO wrap vnode
        %x{
          const old_hook = Opal.global.Preact.options.unmount;
          Opal.global.Preact.options.unmount = function(vnode) {
            #{block.call(`vnode`)};
            if (old_hook) {
              old_hook(vnode);
            }
          }
        }
        nil
      end

      def use_debug_value(&block)
        %x{
          const old_hook = Opal.global.Preact.options.useDebugValue;
          Opal.global.Preact.options.useDebugValue = function(value) {
            #{block.call(`value`)};
            if (old_hook) {
              old_hook(value);
            }
          }
        }
        nil
      end
      
      def vnode(&block)
        %x{
          const old_hook = Opal.global.Preact.options.unmount;
          Opal.global.Preact.options.unmount = function(vnode) {
            #{block.call(`vnode`)};
            if (old_hook) {
              old_hook(vnode);
            }
          }
        }
        nil
      end

    end
  end
end
