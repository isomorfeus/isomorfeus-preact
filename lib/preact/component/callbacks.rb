module Preact::Component::Callbacks
  def self.included(base)
    base.instance_exec do
      def component_did_catch(&block)
        # TODO convert error
        %x{
          var fun = function(error) {
            Opal.Preact.register_active_component(this);
            try {
              #{`this.__ruby_instance`.instance_exec(`error`, &block)};
            } catch (e) { console.error(e.message === Opal.nil ? 'error at' : e.message, e.stack); }
            Opal.Preact.unregister_active_component(this);
          }
          if (self.lucid_preact_component) { self.lucid_preact_component.prototype.componentDidCatch = fun; }
          else { self.preact_component.prototype.componentDidCatch = fun; }
          Opal.Preact.using_did_catch = true;
        }
      end

      def component_did_mount(&block)
        %x{
          let fun = function() {
            Opal.Preact.register_active_component(this);
            try {
              #{`this.__ruby_instance`.instance_exec(&block)};
            } catch (e) { console.error(e.message === Opal.nil ? 'error at' : e.message, e.stack); }
            Opal.Preact.unregister_active_component(this);
          }
          if (self.lucid_preact_component) {
            if (self.lucid_preact_component.prototype.componentDidMount) {
              let fun_one = self.lucid_preact_component.prototype.componentDidMount;
              let fun_two = fun;
              fun = function() {
                fun_one();
                fun_two();
              }
            }
            self.lucid_preact_component.prototype.componentDidMount = fun;
          } else { self.preact_component.prototype.componentDidMount = fun; }
        }
      end

      def component_did_update(&block)
        %x{
          var fun = function(prev_props, prev_state, snapshot) {
            Opal.Preact.register_active_component(this);
            try {
              #{`this.__ruby_instance`.instance_exec(`Opal.Preact.Props.$new({props: prev_props})`,
                                                    `Opal.Preact.State.$new({state: prev_state})`,
                                                    `snapshot`, &block)};
            } catch (e) { console.error(e.message === Opal.nil ? 'error at' : e.message, e.stack); }
            Opal.Preact.unregister_active_component(this);
          }
          if (self.lucid_preact_component) { self.lucid_preact_component.prototype.componentDidUpdate = fun; }
          else { self.preact_component.prototype.componentDidUpdate = fun; }
        }
      end

      def component_will_unmount(&block)
        %x{
          var fun = function() {
            if (typeof this.unsubscriber === "function") { this.unsubscriber(); };
            Opal.Preact.register_active_component(this);
            try {
              #{`this.__ruby_instance`.instance_exec(&block)};
            } catch (e) { console.error(e.message === Opal.nil ? 'error at' : e.message, e.stack); }
            Opal.Preact.unregister_active_component(this);
          }
          if (self.lucid_preact_component) { self.lucid_preact_component.prototype.componentWillUnmount = fun; }
          else { self.preact_component.prototype.componentWillUnmount = fun; }
        }
      end


      def get_derived_state_from_props(&block)
        %x{
          var fun = function(props, state) {
            Opal.Preact.register_active_component(this);
            try {
              var result = #{`this.__ruby_instance`.instance_exec(`Opal.Preact.Props.$new({props: props})`,
                                                                  `Opal.Preact.State.$new({state: state})`, &block)};
            } catch (e) { console.error(e.message === Opal.nil ? 'error at' : e.message, e.stack); }
            Opal.Preact.unregister_active_component(this);
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
            Opal.Preact.register_active_component(this);
            try {
              var result = #{`this.__ruby_instance`.instance_exec(`Opal.Preact.Props.$new({props: prev_props})`,
                                                                  `Opal.Preact.State.$new({state: prev_state})`, &block)};
            } catch (e) { console.error(e.message === Opal.nil ? 'error at' : e.message, e.stack); }
            Opal.Preact.unregister_active_component(this);
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
