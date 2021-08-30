module Isomorfeus
  module Preact
    module Imports
      def self.add
        Isomorfeus.add_common_js_import('preact', 'Preact')
        Isomorfeus.add_common_js_import('preact/hooks', 'PreactHooks')
        Isomorfeus.add_common_js_import('wouter-preact', nil, ['Router', 'Link', 'Redirect', 'Route', 'Switch'])

        Isomorfeus.add_common_js_import('nano-css', 'NanoCSS')
        %w[rule sheet nesting hydrate unitless global keyframes].each do |addon|
          Isomorfeus.add_common_js_import("nano-css/addon/#{addon}", 'NanoCSSAddons', 'addon', addon)
        end
        Isomorfeus.add_common_js_import("nano-css/addon/animate/fadeIn", 'NanoCSSAddons', 'addon', 'fadeIn')
        Isomorfeus.add_common_js_import("nano-css/addon/animate/fadeOut", 'NanoCSSAddons', 'addon', 'fadeOut')

        Isomorfeus.add_ssr_js_import('preact-render-to-string', 'Preact', ['renderToString'])
        Isomorfeus.add_ssr_js_import('wouter-preact/static-location', 'staticLocationHook')

        Isomorfeus.add_web_js_import('wouter-preact/use-location', 'locationHook')
        if Isomorfeus.development?
          Isomorfeus.add_web_js_import('preact-deep-force-update', 'deepForceUpdate')
        end
      end
    end
  end
end
