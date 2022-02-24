module Preact::Component::Callbacks
  def self.included(base)
    base.instance_exec do
      def component_did_catch(&block)
        # TODO convert error
        %x{
          var fun = function(error) {
            const oper = Opal.Preact;
            oper.register_active_component(this);
            try {
              #{`this.__ruby_instance`.instance_exec(`error`, &block)};
            } catch (e) { console.error(e.message === Opal.nil ? 'error at' : e.message, e.stack); }
            oper.unregister_active_component(this);
          }
          if (self.lucid_preact_component) { self.lucid_preact_component.prototype.componentDidCatch = fun; }
          else { self.preact_component.prototype.componentDidCatch = fun; }
          Opal.Preact.using_did_catch = true;
        }
      end

      def component_did_mount(&block)
        %x{
          let fun = function() {
            const oper = Opal.Preact;
            oper.register_active_component(this);
            try { #{`this.__ruby_instance`.instance_exec(&block)}; }
            catch (e) { console.error(e.message === Opal.nil ? 'error at' : e.message, e.stack); }
            if (self.preload_did_mount_proc) { #{`this.__ruby_instance`.instance_exec { self.class.JS[:preload_did_mount_proc].call } } }
            oper.unregister_active_component(this);
          }
          if (self.lucid_preact_component) {
            self.lucid_preact_component.prototype.componentDidMount = fun;
          } else {
            self.preact_component.prototype.componentDidMount = fun;
          }
        }
      end

      def component_did_update(&block)
        %x{
          var fun = function(prev_props, prev_state, snapshot) {
            const oper = Opal.Preact;
            oper.register_active_component(this);
            try {
              #{`this.__ruby_instance`.instance_exec(`oper.Props.$new({props: prev_props})`,
                                                     `oper.State.$new({state: prev_state})`,
                                                     `snapshot`, &block)};
            } catch (e) { console.error(e.message === Opal.nil ? 'error at' : e.message, e.stack); }
            oper.unregister_active_component(this);
          }
          if (self.lucid_preact_component) { self.lucid_preact_component.prototype.componentDidUpdate = fun; }
          else { self.preact_component.prototype.componentDidUpdate = fun; }
        }
      end

      def component_will_unmount(&block)
        %x{
          var fun = function() {
            const oper = Opal.Preact;
            if (typeof this.unsubscriber === "function") { this.unsubscriber(); };
            oper.register_active_component(this);
            try {
              #{`this.__ruby_instance`.instance_exec(&block)};
            } catch (e) { console.error(e.message === Opal.nil ? 'error at' : e.message, e.stack); }
            oper.unregister_active_component(this);
          }
          if (self.lucid_preact_component) { self.lucid_preact_component.prototype.componentWillUnmount = fun; }
          else { self.preact_component.prototype.componentWillUnmount = fun; }
        }
      end


      def get_derived_state_from_props(&block)
        %x{
          var fun = function(props, state) {
            const oper = Opal.Preact;
            oper.register_active_component(this);
            try {
              var result = #{`this.__ruby_instance`.instance_exec(`oper.Props.$new({props: props})`,
                                                                  `oper.State.$new({state: state})`, &block)};
            } catch (e) { console.error(e.message === Opal.nil ? 'error at' : e.message, e.stack); }
            oper.unregister_active_component(this);
            if (typeof result.$to_n === 'function') { result = result.$to_n() }
            if (result === nil) { return null; }
            return result;
          }
          if (self.lucid_preact_component) { self.lucid_preact_component.prototype.getDerivedStateFromProps = fun; }
          else { self.preact_component.prototype.getDerivedStateFromProps = fun; }
        }
      end

      def get_snapshot_before_update(&block)
        %x{
          var fun = function(prev_props, prev_state) {
            const oper = Opal.Preact;
            oper.register_active_component(this);
            try {
              var result = #{`this.__ruby_instance`.instance_exec(`oper.Props.$new({props: prev_props})`,
                                                                  `oper.State.$new({state: prev_state})`, &block)};
            } catch (e) { console.error(e.message === Opal.nil ? 'error at' : e.message, e.stack); }
            oper.unregister_active_component(this);
            if (result === nil) { return null; }
            return result;
          }
          if (self.lucid_preact_component) { self.lucid_preact_component.prototype.getSnapshotBeforeUpdate = fun; }
          else { self.preact_component.prototype.getSnapshotBeforeUpdate = fun; }
        }
      end
    end
  end
end
