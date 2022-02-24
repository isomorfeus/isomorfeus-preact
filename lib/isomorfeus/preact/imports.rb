module Isomorfeus
  module Preact
    module Imports
      def self.add
        Isomorfeus.add_web_js_import('preact/debug') if Isomorfeus.development?
        Isomorfeus.add_common_js_import('preact', 'Preact', '*')
        Isomorfeus.add_common_js_import('preact/hooks', 'PreactHooks', '*')
        Isomorfeus.add_common_js_import('wouter-preact', nil, ['Router', 'Link', 'Redirect', 'Route', 'Switch'])

        Isomorfeus.add_ssr_js_import('preact-render-to-string', 'Preact', ['render'], nil, 'renderToString')
        Isomorfeus.add_ssr_js_import('wouter-preact/static-location', 'staticLocationHook')

        Isomorfeus.add_web_js_import('wouter-preact/use-location', 'locationHook')

        if Dir.exist?(Isomorfeus.app_root)
          if File.exist?(File.join(Isomorfeus.app_root, 'isomorfeus_loader.rb'))
            Isomorfeus.add_common_ruby_import('isomorfeus_loader')
            Isomorfeus.add_ssr_ruby_import('isomorfeus/preact/ssr/top_level')
            Isomorfeus.add_ssr_ruby_import('isomorfeus/preact/ssr/render_core')
            Isomorfeus.add_ssr_ruby_import('isomorfeus/preact/ssr/history')
          end
        end
      end
    end
  end
end
