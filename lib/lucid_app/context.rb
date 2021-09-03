module LucidApp
  module Context
    def self.create_application_context
      nano_css = `null`
      css_server = `null`
      css_server = `document.getElementById('css-server-side')` unless on_ssr?
      %x{
        let og = Opal.global;
        nano_css = (css_server) ? og.NanoCSS.create({ sh: css_server }) : og.NanoCSS.create();
        og.NanoCSSAddons.rule(nano_css);
        og.NanoCSSAddons.sheet(nano_css);
        og.NanoCSSAddons.nesting(nano_css);
        og.NanoCSSAddons.hydrate(nano_css);
        og.NanoCSSAddons.unitless(nano_css);
        og.NanoCSSAddons.global(nano_css);
        og.NanoCSSAddons.keyframes(nano_css);
        og.NanoCSSAddons.fadeIn(nano_css);
        og.NanoCSSAddons.fadeOut(nano_css);
        og.NanoCSSInstance = nano_css;
      }
      Preact.create_context('LucidApplicationContext', { iso_store: Isomorfeus.store, nano_css: nano_css })
    end
  end
end
