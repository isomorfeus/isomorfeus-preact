module Isomorfeus
  module PreactViewHelper
    def self.included(base)
      base.include Isomorfeus::AssetManager::ViewHelper
    end

    def cached_mount_component(component_name, props = {}, asset_key = 'ssr.js', skip_ssr: false, use_ssr: false, max_passes: 4)
      key = "#{component_name}#{props}#{asset}"
      if Isomorfeus.production?
        render_result, @ssr_response_status, @ssr_styles = component_cache.fetch(key)
        return render_result if render_result
      end
      render_result = mount_component(component_name, props, asset_key, skip_ssr: skip_ssr, use_ssr: use_ssr, max_passes: max_passes)
      status = ssr_response_status
      component_cache.store(key, render_result, status, ssr_styles) if status >= 200 && status < 300
      render_result
    end

    def mount_component(component_name, props = {}, asset_key = 'ssr.js', skip_ssr: false, use_ssr: false, max_passes: 4)
      @ssr_response_status = nil
      @ssr_styles = nil
      thread_id_asset = "#{Thread.current.object_id}#{asset_key}"
      render_result = "<div data-iso-env=\"#{Isomorfeus.env}\" data-iso-root=\"#{component_name}\" data-iso-props='#{Oj.dump(props, mode: :strict)}'"
      if !skip_ssr && (Isomorfeus.server_side_rendering || use_ssr)
        if Isomorfeus.development?
          # always create a new context, effectively reloading code
          # delete the existing context first, saves memory
          if Isomorfeus.ssr_contexts.key?(thread_id_asset)
            uuid = Isomorfeus.ssr_contexts[thread_id_asset].instance_variable_get(:@uuid)
            runtime = Isomorfeus.ssr_contexts[thread_id_asset].instance_variable_get(:@runtime)
            runtime.vm.delete_context(uuid)
          end
          begin
            init_speednode_context(asset_key, thread_id_asset)
          rescue Exception => e
            Isomorfeus.raise_error(message: "Server Side Rendering: Failed creating context for #{asset_key}. Error: #{e.message}", stack: e.backtrace)
          end
        else
          unless Isomorfeus.ssr_contexts.key?(thread_id_asset)
            init_speednode_context(asset_key, thread_id_asset)
          end
        end

        start_time = Time.now if Isomorfeus.development?
        pass = 0
        # if location_host and scheme are given and if Transport is loaded, connect and then render,
        # otherwise do not render because only one pass is required
        ws_scheme = props[:location_scheme] == 'https:' ? 'wss:' : 'ws:'
        location_host = props[:location_host] ? props[:location_host] : 'localhost'
        api_ws_path = Isomorfeus.respond_to?(:api_websocket_path) ? Isomorfeus.api_websocket_path : ''
        transport_ws_url = ws_scheme + location_host + api_ws_path

        # build javascript for rendering first pass
        # it will initialize buffers to guard against leaks, maybe caused by previous exceptions
        javascript = <<~JAVASCRIPT
          global.Opal.Preact.render_buffer = [];
          global.Opal.Preact.active_components = [];
          global.Opal.Preact.active_redux_components = [];
          global.FirstPassFinished = false;
          global.Exception = false;
          global.IsomorfeusSessionId = '#{Thread.current[:isomorfeus_session_id]}';
          global.Opal.Isomorfeus['$env=']('#{Isomorfeus.env}');
          if (typeof global.Opal.Isomorfeus["$current_locale="] === 'function') {
            global.Opal.Isomorfeus["$current_locale="]('#{props[:locale]}');
          } else if (typeof global.Opal.Isomorfeus["$negotiated_locale="] === 'function') { // remove later on
            global.Opal.Isomorfeus["$negotiated_locale="]('#{props[:locale]}');
          }
          global.Opal.Isomorfeus['$force_init!']();
          global.Opal.Isomorfeus['$ssr_response_status='](200);
          global.Opal.Isomorfeus.TopLevel['$ssr_route_path=']('#{props[:location]}');
          let api_ws_path = '#{api_ws_path}';
          let exception;
          if (typeof global.Opal.Isomorfeus.Transport !== 'undefined' && api_ws_path !== '') {
            global.Opal.Isomorfeus.TopLevel["$transport_ws_url="]("#{transport_ws_url}");
            global.Opal.send(global.Opal.Isomorfeus.Transport.$promise_connect(global.IsomorfeusSessionId), 'then', [], ($$1 = function(){
              try {
                global.Opal.Isomorfeus.TopLevel.$render_component_to_string('#{component_name}', #{Oj.dump(props, mode: :strict)});
                global.FirstPassFinished = 'transport';
              } catch (e) {
                global.Exception = e;
                global.FirstPassFinished = 'transport';
              }
            }, $$1.$$s = this, $$1.$$arity = 0, $$1))
            return false;
          } else { global.FirstPassFinished = true; return true; };
        JAVASCRIPT
        # execute first render pass
        begin
          first_pass_skipped = Isomorfeus.ssr_contexts[thread_id_asset].exec(javascript)
        rescue Exception => e
          Isomorfeus.raise_error(error: e)
        end
        # wait for first pass to finish
        unless first_pass_skipped
          pass += 1
          first_pass_finished, exception = Isomorfeus.ssr_contexts[thread_id_asset].exec('return [global.FirstPassFinished, global.Exception ? { message: global.Exception.message, stack: global.Exception.stack } : false ]')
          Isomorfeus.raise_error(message: "Server Side Rendering: #{exception['message']}", stack: exception['stack']) if exception
          unless first_pass_finished
            start_time = Time.now
            while !first_pass_finished
              break if (Time.now - start_time) > 10
              sleep 0.01
              first_pass_finished = Isomorfeus.ssr_contexts[thread_id_asset].exec('return global.FirstPassFinished')
            end
          end
          # wait for transport requests to finish
          if first_pass_finished == 'transport'
            transport_busy = Isomorfeus.ssr_contexts[thread_id_asset].exec('return global.Opal.Isomorfeus.Transport["$busy?"]()')
            if transport_busy
              start_time = Time.now
              while transport_busy
                break if (Time.now - start_time) > 5
                sleep 0.01
                transport_busy = Isomorfeus.ssr_contexts[thread_id_asset].exec('return global.Opal.Isomorfeus.Transport["$busy?"]()')
              end
            end
          end
        end
        # build javascript for additional render passes
        # guard against leaks from first pass, maybe because of a exception
        javascript = <<~JAVASCRIPT
          global.Opal.Preact.render_buffer = [];
          global.Opal.Preact.active_components = [];
          global.Opal.Preact.active_redux_components = [];
          global.Exception = false;
          let rendered_tree;
          let ssr_styles;
          let component;
          try {
            rendered_tree = global.Opal.Isomorfeus.TopLevel.$render_component_to_string('#{component_name}', #{Oj.dump(props, mode: :strict)});
          } catch (e) {
            global.Exception = e;
          }
          let application_state = global.Opal.Isomorfeus.store.native.getState();
          let still_busy = (#{pass}<2) ? global.Opal.Isomorfeus.store['$recently_dispatched?']() : false;
          if (typeof global.Opal.Isomorfeus.Transport !== 'undefined' && global.Opal.Isomorfeus.Transport["$busy?"]()) { still_busy = true; }
          if (typeof global.NanoCSSInstance !== 'undefined') { ssr_styles = global.NanoCSSInstance.raw }
          return [rendered_tree, application_state, ssr_styles, global.Opal.Isomorfeus['$ssr_response_status'](), still_busy, global.Exception ? { message: global.Exception.message, stack: global.Exception.stack } : false];
        JAVASCRIPT
        # execute further render passes
        pass += 1
        rendered_tree, application_state, @ssr_styles, @ssr_response_status, still_busy, exception = Isomorfeus.ssr_contexts[thread_id_asset].exec(javascript)
        start_time = Time.now
        while still_busy
          break if (Time.now - start_time) > 5
          while still_busy
            break if (Time.now - start_time) > 4
            sleep 0.01
            still_busy = Isomorfeus.ssr_contexts[thread_id_asset].exec('return (typeof global.Opal.Isomorfeus.Transport !== "undefined") ? global.Opal.Isomorfeus.Transport["$busy?"]() : false')
          end
          pass += 1
          rendered_tree, application_state, @ssr_styles, @ssr_response_status, still_busy, exception = Isomorfeus.ssr_contexts[thread_id_asset].exec(javascript)
          break if pass >= max_passes
        end
        javascript = <<~JAVASCRIPT
          if (typeof global.Opal.Isomorfeus.Transport !== 'undefined') { global.Opal.Isomorfeus.Transport.$disconnect(); }
        JAVASCRIPT
        Isomorfeus.ssr_contexts[thread_id_asset].exec(javascript)
        Isomorfeus.raise_error(message: exception['message'], stack: exception['stack']) if exception
        render_result << " data-iso-hydrated='true'" if rendered_tree
        if Isomorfeus.respond_to?(:current_user) && Isomorfeus.current_user && !Isomorfeus.current_user.anonymous?
          render_result << " data-iso-usid=#{Oj.dump(Isomorfeus.current_user.sid, mode: :strict)}"
        end
        render_result << " data-iso-nloc='#{props[:locale]}'>"
        render_result << (rendered_tree ? rendered_tree : "SSR didn't work")
      else
        if Isomorfeus.respond_to?(:current_user) && Isomorfeus.current_user && !Isomorfeus.current_user.anonymous?
          render_result << " data-iso-usid=#{Oj.dump(Isomorfeus.current_user.sid, mode: :strict)}"
        end
        render_result << " data-iso-nloc='#{props[:locale]}'>"
      end
      render_result << '</div>'
      if Isomorfeus.server_side_rendering
        render_result = "<script type='application/javascript'>\nServerSideRenderingStateJSON = #{Oj.dump(application_state, mode: :strict)}\n</script>\n" << render_result
      end
      STDERR.puts "PreactViewHelper Server Side Rendering rendered #{pass} passes and took ~#{((Time.now - start_time)*1000).to_i}ms" if Isomorfeus.development? && !skip_ssr
      render_result
    end

    def ssr_response_status
      @ssr_response_status || 200
    end

    def ssr_styles
      @ssr_styles || ''
    end

    private

    def asset_manager
      @_asset_manager ||= Isomorfeus::AssetManager.new
    end

    def component_cache
      @_component_cache ||= Isomorfeus.component_cache_init_block.call
    end

    def init_speednode_context(asset_key, thread_id_asset)
      asset = Isomorfeus.assets[asset_key]
      raise "#{self.class.name}: Asset not found: #{asset_key}" unless asset
      asset_manager.transition(asset_key, asset)
      Isomorfeus.ssr_contexts[thread_id_asset] = ExecJS.permissive_compile(asset.bundle)
    end
  end
end
