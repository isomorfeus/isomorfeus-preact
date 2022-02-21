module Isomorfeus
  module SSR
    %x{
      self.first_pass = function(session_id, env, locale, location, api_ws_path, transport_ws_url, component_name, props) {
        global.Opal.Preact.render_buffer = [];
        global.Opal.Preact.active_components = [];
        global.Opal.Preact.active_redux_components = [];
        global.FirstPassFinished = false;
        global.NeedFurtherPass = false;
        global.RenderedTree = '';
        global.Exception = false;
        global.IsomorfeusSessionId = session_id;
        global.HasTransport = (typeof global.Opal.Isomorfeus.Transport !== 'undefined') && (api_ws_path !== '');
        global.Opal.Isomorfeus['$env='](env);
        if (typeof global.Opal.Isomorfeus["$current_locale="] === 'function') { global.Opal.Isomorfeus["$current_locale="](locale); }
        global.Opal.Isomorfeus['$force_init!']();
        global.Opal.Isomorfeus['$ssr_response_status='](200);
        global.Opal.Isomorfeus.TopLevel['$ssr_route_path='](location);
        if (global.HasTransport) {
          global.Opal.Isomorfeus.TopLevel["$transport_ws_url="](transport_ws_url);
          global.Opal.send(global.Opal.Isomorfeus.Transport.$promise_connect(global.IsomorfeusSessionId), 'then', [], ($$1 = function(){
            try {
              global.RenderedTree = global.Opal.Isomorfeus.TopLevel.$render_component_to_string(component_name, props);
              global.NeedFurtherPass = self.still_busy();
              global.FirstPassFinished = true;
            } catch (e) {
              global.Exception = e;
              global.NeedFurtherPass = false;
            }
          }, $$1.$$s = this, $$1.$$arity = 0, $$1))
        } else {
          try {
            global.RenderedTree = global.Opal.Isomorfeus.TopLevel.$render_component_to_string(component_name, props);
            global.NeedFurtherPass = self.store_busy();
          } catch (e) {
            global.Exception = e;
            global.NeedFurtherPass = false;
          }
        };
        return [global.HasTransport, global.NeedFurtherPass, global.Exception ? { message: global.Exception.message, stack: global.Exception.stack } : false];
      }

      self.first_pass_result = function() {
        let ssr_styles;
        let application_state = global.Opal.Isomorfeus.store.native.getState();
        if (typeof global.NanoCSSInstance !== 'undefined') { ssr_styles = global.NanoCSSInstance.raw }
        return [global.RenderedTree, application_state, ssr_styles, global.Opal.Isomorfeus['$ssr_response_status'](), global.Exception ? { message: global.Exception.message, stack: global.Exception.stack } : false];
      }

      self.further_pass = function(component_name, props) {
        global.Opal.Preact.render_buffer = [];
        global.Opal.Preact.active_components = [];
        global.Opal.Preact.active_redux_components = [];
        global.Exception = false;
        let rendered_tree;
        let ssr_styles;
        try {
          rendered_tree = global.Opal.Isomorfeus.TopLevel.$render_component_to_string(component_name, props);
        } catch (e) {
          global.Exception = e;
        }
        let application_state = global.Opal.Isomorfeus.store.native.getState();
        if (typeof global.NanoCSSInstance !== 'undefined') { ssr_styles = global.NanoCSSInstance.raw }
        global.NeedFurtherPass = ((global.HasTransport && global.Opal.Isomorfeus.Transport["$busy?"]()) || self.store_busy());
        return [rendered_tree, application_state, ssr_styles, global.Opal.Isomorfeus['$ssr_response_status'](), global.NeedFurtherPass, global.Exception ? { message: global.Exception.message, stack: global.Exception.stack } : false];
      }

      self.still_busy = function(){
        if (global.Opal.Isomorfeus.Transport["$busy?"]()) { return true; }
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