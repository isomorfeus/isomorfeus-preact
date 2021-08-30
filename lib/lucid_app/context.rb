module LucidApp
  module Context
    def self.create_application_context
      nano_css = `null`
      css_server = `null`
      css_server = `document.getElementById('css-server-side')` unless on_ssr?
      %x{
        let og = Opal.global;
        nano_css = (css_server) ? og.NanoCSS.create({ sh: css_server }) : og.NanoCSS.create();
        og.NanoCSSAddOns.rule(nano_css);
        og.NanoCSSAddOns.sheet(nano_css);
        og.NanoCSSAddOns.nesting(nano_css);
        og.NanoCSSAddOns.hydrate(nano_css);
        og.NanoCSSAddOns.unitless(nano_css);
        og.NanoCSSAddOns.global(nano_css);
        og.NanoCSSAddOns.keyframes(nano_css);
        og.NanoCSSAddOns.fade_in(nano_css);
        og.NanoCSSAddOns.fade_out(nano_css);
        og.NanoCSSInstance = nano_css;
      }
      Preact.create_context('LucidApplicationContext', { iso_store: Isomorfeus.store, nano_css: nano_css })
    end
  end
end
