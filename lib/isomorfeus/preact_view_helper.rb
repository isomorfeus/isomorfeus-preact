module Isomorfeus
  module PreactViewHelper
    def self.included(base)
      base.include Isomorfeus::AssetManager::ViewHelper
    end

    def cached_mount_component(component_name, props = {}, asset_key = 'ssr.js', skip_ssr: false, use_ssr: false, max_passes: 4, refresh: false)
      key = "#{component_name}#{props}#{asset}"
      if !Isomorfeus.development? && !refresh
        render_result, @ssr_response_status, @ssr_styles = component_cache.fetch(key)
        return render_result if render_result
      end
      render_result = mount_component(component_name, props, asset_key, skip_ssr: skip_ssr, use_ssr: use_ssr, max_passes: max_passes)
      status = ssr_response_status
      component_cache.store(key, render_result, status, ssr_styles) if status >= 200 && status < 300
      render_result
    end

    def mount_component(component_name, props = {}, asset_key = 'ssr.js', skip_ssr: false, use_ssr: false, max_passes: 4)
      ssr_start_time = Time.now if Isomorfeus.development?
      @ssr_response_status = nil
      @ssr_styles = nil
      render_result = "<div data-iso-env=\"#{Isomorfeus.env}\" data-iso-root=\"#{component_name}\" data-iso-props='#{Oj.dump(props, mode: :strict)}'"
      if !skip_ssr && (Isomorfeus.server_side_rendering || use_ssr)
        thread_id_asset = "#{Thread.current.object_id}#{asset_key}"
        begin
          if Isomorfeus.development?
            init_speednode_context(asset_key, thread_id_asset)
          elsif !Isomorfeus.ssr_contexts.key?(thread_id_asset)
            init_speednode_context(asset_key, thread_id_asset)
          end
        rescue Exception => e
          Isomorfeus.raise_error(message: "Server Side Rendering: Failed creating context for #{asset_key}. Error: #{e.message}", stack: e.backtrace)
        end

        ctx = Isomorfeus.ssr_contexts[thread_id_asset]
        pass = 0
        # if location_host and scheme are given and if Transport is loaded, connect and then render
        ws_scheme = props[:location_scheme] == 'https:' ? 'wss:' : 'ws:'
        location_host = props[:location_host] ? props[:location_host] : 'localhost'
        api_ws_path = Isomorfeus.respond_to?(:api_websocket_path) ? Isomorfeus.api_websocket_path : ''
        transport_ws_url = ws_scheme + location_host + api_ws_path

        # build javascript for rendering first pass
        # it will initialize buffers to guard against leaks, maybe caused by previous exceptions
        javascript = <<~JAVASCRIPT
        return Opal.Isomorfeus.SSR.mount_component('#{Thread.current[:isomorfeus_session_id]}', '#{Isomorfeus.env}', '#{props[:locale]}', '#{props[:location]}', '#{transport_ws_url}', '#{component_name}', #{Oj.dump(props, mode: :strict)}, #{max_passes})
        JAVASCRIPT

        begin
          ctx.exec(javascript)
        rescue Exception => e
          Isomorfeus.raise_error(error: e)
        end

        sleep 0.001 # give other threads that would respond to a request from node/SSR a chance to run
        rendering = ctx.eval_script(key: :rendering)
        if rendering
          start_time = Time.now
          while rendering
            break if (Time.now - start_time) > 10
            sleep 0.005
            rendering = ctx.eval_script(key: :rendering)
          end
        end

        rendered_tree, application_state, @ssr_styles, @ssr_response_status, passes, exception = ctx.eval_script(key: :get_result)
        Isomorfeus.raise_error(message: "Server Side Rendering: #{exception['message']}", stack: exception['stack']) if exception

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
      if Isomorfeus.server_side_rendering && !skip_ssr
        render_result = "<script type='application/javascript'>\nServerSideRenderingStateJSON = #{Oj.dump(application_state, mode: :strict)}\n</script>\n" << render_result
        puts "PreactViewHelper Server Side Rendering rendered #{passes} passes and took ~#{((Time.now - ssr_start_time)*1000).to_i}ms" if Isomorfeus.development?
      end
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
      if !Isomorfeus.ssr_contexts.key?(thread_id_asset) || !asset.bundled?
        if Isomorfeus.ssr_contexts.key?(thread_id_asset)
          uuid = Isomorfeus.ssr_contexts[thread_id_asset].instance_variable_get(:@uuid)
          runtime = Isomorfeus.ssr_contexts[thread_id_asset].instance_variable_get(:@runtime)
          runtime.vm.delete_context(uuid)
        end
        asset_manager.transition(asset_key, asset)
        Isomorfeus.ssr_contexts[thread_id_asset] = ExecJS.permissive_compile(asset.bundle)
        ctx = Isomorfeus.ssr_contexts[thread_id_asset]
        ctx.add_script(key: :get_result, source: 'Opal.Isomorfeus.SSR.get_result()')
        ctx.add_script(key: :rendering, source: 'global.Rendering')
      end
    end

    def ssr_mod
      @_ssr_mod ||= Opal.compile(File.read(File.expand_path(File.join(File.dirname(__FILE__), 'ssr.rb'))), { use_strict: true })
    end

    def top_level_mod
      @_top_level_mod ||= Opal.compile(File.read(File.expand_path(File.join(File.dirname(__FILE__), 'top_level_ssr.rb'))), { use_strict: true })
    end
  end
end
