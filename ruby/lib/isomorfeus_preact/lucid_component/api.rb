module LucidComponent
  module Api
    def self.included(base)
      base.instance_exec do
        # store
        attr_accessor :app_store
        attr_accessor :class_store
        attr_accessor :store

        def class_store
          @class_store ||= ::LucidComponent::ClassStoreProxy.new(self.to_s)
        end

        # preloading
        def preload(&block)
          `base.preload_block = block`
          component_did_mount do
            unless self.state.preloaded
              @_preload_promise.then { self.state.preloaded = true }.fail do |result|
                err_text = "#{self.class.name}: preloading failed, last result: #{result.nil? ? 'nil' : result}!"
                `console.error(err_text)`
              end
            end
          end
        end

        def while_loading(option = nil, &block)
          wl_block = proc do
            if @_preload_promise.resolved?
              instance_exec(&`base.render_block`)
            else
              instance_exec(&block)
            end
          end
          `base.while_loading_block = wl_block`
        end
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
        @_preload_promise = instance_exec(&self.class.JS[:preload_block])
        @_preload_promise.resolved?
      end

      def preloaded?
        !!state.preloaded
      end

      # requires transport
      def current_user
        Isomorfeus.current_user
      end
    end
  end
end
