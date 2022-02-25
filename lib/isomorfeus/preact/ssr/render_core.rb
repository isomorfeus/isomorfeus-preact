module Isomorfeus
  module SSR
    %x{
      self.first_pass = function(component_name, props) {
        if (global.HasTransport) {
          #{
            Isomorfeus.set_current_user(nil)
            Isomorfeus::Transport.promise_connect(`global.IsomorfeusSessionId`)
              .then { `self.async_render_pass(component_name, props)` }
              .fail do
                %x{
                  global.ConnectRetries--;
                  if (global.ConnectRetries > 0) {
                    self.first_pass(component_name, props);
                  } else {
                    global.Exception = new Error('Transport within SSR unable to connect!');
                    self.finish_render();
                  }
                }
              end
          }
        } else {
          self.async_render_pass(component_name, props);
        };
      }

      self.async_render_pass = function(component_name, props) {
        if (global.RenderPass < global.MaxPasses) {
          self.render_pass(component_name, props);
          if (global.Exception) {
            self.finish_render();
            return;
          }
          setTimeout(self.check_and_render, 1, component_name, props);
        } else { self.finish_render(); }
      }

      self.render_pass = function(component_name, props) {
        const oper = global.Opal.Preact;
        oper.render_buffer = [];
        oper.active_components = [];
        oper.active_redux_components = [];
        global.NeedAnotherPass = false;
        try {
          global.RenderPass++;
          global.RenderedTree = global.Opal.Isomorfeus.TopLevel.$render_component_to_string(component_name, props);
        } catch (e) {
          global.RenderedTree = 'exception';
          global.Exception = e;
        }
      }

      self.check_and_render = function(component_name, props) {
        if (self.still_busy()) {
          global.NeedAnotherPass = true;
          setTimeout(self.check_and_render, 1, component_name, props);
        } else if (global.NeedAnotherPass) {
          global.NeedAnotherPass = false;
          self.async_render_pass(component_name, props);
        } else { self.finish_render(); }
      }

      self.finish_render = function() {
        global.Rendering = false;
        if (global.HasTransport) { self.$disconnect_transport(); }
      }

      self.still_busy = function() {
        if (global.Opal.Isomorfeus?.Transport?.["$busy?"]?.()) { return true; }
        let nfp = global.Opal.Isomorfeus.store["$recently_dispatched?"]();
        return (nfp == global.Opal.nil) ? false : nfp;
      }

      self.get_exception = function() {
        if (global.Exception) { return { message: global.Exception.message, stack: global.Exception.stack }; }
        else { return null; }
      }

      self.get_result = function() {
        const opi = global.Opal.Isomorfeus;
        let application_state = opi.store.native.getState();
        let ssr_styles = global?.NanoCSSInstance?.raw;
        return [global.RenderedTree, application_state, ssr_styles, opi['$ssr_response_status'](), global.RenderPass, self.get_exception()];
      }

      self.mount_component = function(session_id, env, locale, location, transport_ws_url, component_name, props, max_passes) {
        const opi = global.Opal.Isomorfeus;
        global.ConnectRetries = 5;
        global.RenderPass = 0;
        global.Rendering = true;
        global.MaxPasses = max_passes;
        global.IsomorfeusSessionId = session_id;
        global.RenderedTree = null;
        global.Exception = false;
        global.HasTransport = (typeof opi.Transport !== 'undefined');
        if (global.HasTransport) { opi.TopLevel["$transport_ws_url="](transport_ws_url); }
        opi['$env='](env);
        if (typeof opi["$current_locale="] === 'function') { opi["$current_locale="](locale); }
        opi['$force_init!']();
        opi['$ssr_response_status='](200);
        opi.TopLevel['$ssr_route_path='](location);

        self.first_pass(component_name, props);
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
