module LucidComponent::Api
  def self.included(base)
    base.instance_exec do
      # stores
      attr_accessor :app_store
      attr_accessor :class_store

      def class_store
        @class_store ||= ::LucidComponent::ClassStoreProxy.new(self.to_s)
      end

      # preloading
      def preload(&block)
        `base.preload_block = block`
        component_did_mount do
          unless self.state.preloaded
            @_preload_promise.then { self.state.preloaded = true } if @_preload_promise
          end
        end
      end

      def while_loading(option = nil, &block)
        wl_block = proc do
          if @_preload_promise && @_preload_promise.resolved?
            instance_exec(&`base.render_block`)
          else
            instance_exec(&block)
          end
        end
        `base.while_loading_block = wl_block`
      end

      # styles
      def styles(styles_hash = nil, &block)
        styles_hash = block.call if block_given?
        if styles_hash
          component_name = self.to_s
          %x{
            let rule_name = component_name.replace(/:/g, '_');
            let ogni = Opal.global.NanoCSSInstance;
            if (base.css_styles && #{Isomorfeus.production?}) { return base.css_styles; }
            else if(#{Isomorfeus.development?}) {
              if (#{on_browser?}) {
                ogni.delete_from_sheet(rule_name);
                ogni.delete_from_rule_blocks(rule_name);
                ogni.hydrate_force_put = true;
              }
            }
            if (typeof styles_hash.$is_wrapped_style !== 'undefined') {
              base.css_styles = styles_hash;
            } else {
              let css;
              if (typeof styles_hash.$to_n === 'function') { css = styles_hash.$to_n(); }
              else { css = styles_hash; }
              let nano_styles = ogni.sheet(css, rule_name);
              base.css_styles = #{::LucidComponent::StylesWrapper.new(`nano_styles`)};
            }
          }
        end
        %x{
          if (!base.css_styles) { return nil; }
          return base.css_styles;
        }
      end
      alias_method :styles=, :styles
    end

    # stores
    def local_store
      LocalStore
    end

    def session_store
      SessionStore
    end

    def theme
      props.theme
    end

    # preloading
    def execute_preload_block
      begin
        @_preload_promise = instance_exec(&self.class.JS[:preload_block])
      rescue => e
        %x{
          console.error(e.message);
          console.error(e.stack);
        }
      end
      if @_preload_promise
        @_preload_promise.fail do |result|
          err_text = "#{self.class.name}: preloading failed, last result: #{result.nil? ? 'nil' : result}!"
          `console.error(err_text)`
        end
        @_preload_promise.resolved?
      else
        false
      end
    end

    def preloaded?
      !!state.preloaded
    end

    # styles
    def styles
      %x{
        let c = self.$class()
        if (typeof(c.css_styles) === 'undefined') { return nil; }
        return c.css_styles;
      }
    end

    # requires transport
    def current_user
      Isomorfeus.current_user
    end
  end
end
