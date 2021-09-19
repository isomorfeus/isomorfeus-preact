module Isomorfeus
  module Preact
    module Imports
      def self.add
        Isomorfeus.add_common_js_import('preact', 'Preact', '*')
        Isomorfeus.add_common_js_import('preact/hooks', 'PreactHooks', '*')
        Isomorfeus.add_common_js_import('wouter-preact', nil, ['Router', 'Link', 'Redirect', 'Route', 'Switch'])

        Isomorfeus.add_ssr_js_import('preact-render-to-string', 'Preact', ['render'], nil, 'renderToString')
        Isomorfeus.add_ssr_js_import('wouter-preact/static-location', 'staticLocationHook')

        Isomorfeus.add_web_js_import('wouter-preact/use-location', 'locationHook')

        if Dir.exist?(Isomorfeus.app_root)
          Isomorfeus.add_common_ruby_import('isomorfeus_loader') if File.exist?(File.join(Isomorfeus.app_root, 'isomorfeus_loader.rb'))
        end
      end
    end
  end
end
