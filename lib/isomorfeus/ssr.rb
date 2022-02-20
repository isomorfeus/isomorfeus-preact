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
        global.HasStore = typeof global.Opal.Isomorfeus.store !== 'undefined';
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
              let nfp = global.Opal.Isomorfeus.Transport["$busy?"]() || global.Opal.Isomorfeus.store['$recently_dispatched?']();
              global.NeedFurtherPass = (nfp == nil) ? false : nfp;
              global.FirstPassFinished = true;
            } catch (e) {
              global.Exception = e;
              global.NeedFurtherPass = false;
            }
          }, $$1.$$s = this, $$1.$$arity = 0, $$1))
        } else {
          try {
            global.RenderedTree = global.Opal.Isomorfeus.TopLevel.$render_component_to_string(component_name, props);
            if (global.HasStore) {
              let nfp = global.Opal.Isomorfeus.store['$recently_dispatched?']();
              global.NeedFurtherPass = (nfp == nil) ? false : nfp;
            }
          } catch (e) {
            global.Exception = e;
            global.NeedFurtherPass = false;
          }
        };
        return [global.HasTransport, global.HasStore, global.NeedFurtherPass, global.Exception ? { message: global.Exception.message, stack: global.Exception.stack } : false];
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
        let nfp = (global.HasTransport && global.Opal.Isomorfeus.Transport["$busy?"]()) || (global.HasStore && global.Opal.Isomorfeus.store["$recently_dispatched?"]());
        global.NeedFurtherPass = (nfp == nil) ? false : nfp;
        return [rendered_tree, application_state, ssr_styles, global.Opal.Isomorfeus['$ssr_response_status'](), global.NeedFurtherPass, global.Exception ? { message: global.Exception.message, stack: global.Exception.stack } : false];
      }

      self.still_busy = function(){
        let nfp = global.Opal.Isomorfeus.Transport["$busy?"]() || global.Opal.Isomorfeus.store["$recently_dispatched?"]();
        return (nfp == global.Opal.nil) ? false : nfp;
      }

      self.store_busy = function() {
        let nfp = global.Opal.Isomorfeus.store["$recently_dispatched?"]();
        return (nfp == global.Opal.nil) ? false : nfp;
      }
    }
  end
end