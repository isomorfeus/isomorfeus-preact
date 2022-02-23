module Isomorfeus
  module SSR
    %x{
      self.first_pass = function(session_id, env, locale, location, transport_ws_url, component_name, props) {
        const oper = global.Opal.Preact;
        const opi = global.Opal.Isomorfeus;
        oper.render_buffer = [];
        oper.active_components = [];
        oper.active_redux_components = [];
        global.FirstPassFinished = false;
        global.NeedFurtherPass = false;
        global.RenderedTree = '';
        global.Exception = false;
        global.IsomorfeusSessionId = session_id;
        global.HasTransport = (typeof opi.Transport !== 'undefined');
        opi['$env='](env);
        if (typeof opi["$current_locale="] === 'function') { opi["$current_locale="](locale); }
        opi['$force_init!']();
        opi['$ssr_response_status='](200);
        opi.TopLevel['$ssr_route_path='](location);
        if (global.HasTransport) {
          opi.TopLevel["$transport_ws_url="](transport_ws_url);
          let $$1;
          global.Opal.send(opi.Transport.$promise_connect(global.IsomorfeusSessionId), 'then', [], ($$1 = function(){
            try {
              global.RenderedTree = opi.TopLevel.$render_component_to_string(component_name, props);
              global.NeedFurtherPass = self.still_busy();
              global.FirstPassFinished = true;
            } catch (e) {
              global.Exception = e;
              global.FirstPassFinished = true;
              global.NeedFurtherPass = false;
            }
          }, $$1.$$s = this, $$1.$$arity = 0, $$1))
          global.NeedFurtherPass = true;
        } else {
          try {
            global.RenderedTree = opi.TopLevel.$render_component_to_string(component_name, props);
            global.NeedFurtherPass = self.store_busy();
          } catch (e) {
            global.Exception = e;
            global.FirstPassFinished = true;
            global.NeedFurtherPass = false;
          }
        };
        return [global.HasTransport, global.NeedFurtherPass, self.get_exception()];
      }

      self.first_pass_check = function() {
        return [global.FirstPassFinished, global.NeedFurtherPass, self.get_exception()];
      }

      self.first_pass_result = function() {
        const opi = global.Opal.Isomorfeus;
        let application_state = opi.store.native.getState();
        let ssr_styles = global?.NanoCSSInstance?.raw;
        return [global.RenderedTree, application_state, ssr_styles, opi['$ssr_response_status'](), self.get_exception()];
      }

      self.further_pass = function(component_name, props) {
        const oper = global.Opal.Preact;
        const opi = global.Opal.Isomorfeus;
        oper.render_buffer = [];
        oper.active_components = [];
        oper.active_redux_components = [];
        global.NeedFurtherPass = false;
        global.Exception = false;
        let application_state = null;
        let rendered_tree = null;
        let ssr_styles = null;
        try {
          rendered_tree = opi.TopLevel.$render_component_to_string(component_name, props);
          application_state = opi.store.native.getState();
          ssr_styles = global?.NanoCSSInstance?.raw;
          global.NeedFurtherPass = self.still_busy();
        } catch (e) {
          global.Exception = e;
        }
        return [rendered_tree, application_state, ssr_styles, opi['$ssr_response_status'](), global.NeedFurtherPass, self.get_exception()];
      }

      self.get_exception = function() {
        if (global.Exception) { return { message: global.Exception.message, stack: global.Exception.stack }; }
        return false;
      }

      self.still_busy = function(){
        if (global.Opal.Isomorfeus?.Transport?.["$busy?"]?.()) { return true; }
        return self.store_busy();
      }

      self.store_busy = function() {
        let nfp = global.Opal.Isomorfeus.store["$recently_dispatched?"]();
        return (nfp == global.Opal.nil) ? false : nfp;
      }
    }

    def self.disconnect_transport
      Isomorfeus::Transport::RequestAgent.agents.each do |agent_id, agent|
        agent.promise.reject() unless agent.promise.realized?
        Isomorfeus::Transport::RequestAgent.del!(agent_id)
      end
      Isomorfeus::Transport.instance_variable_set(:@requests_in_progress, { requests: {}, agent_ids: {} })
      Isomorfeus::Transport.disconnect
    end
  end
end