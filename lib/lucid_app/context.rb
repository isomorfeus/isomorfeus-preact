module LucidApp
  module Context
    def self.create_application_context
      nano_css = `null`
      css_server = `null`
      css_server = `document.getElementById('css-server-side')` unless on_ssr?
      %x{
        n = Opal.NanoCSS;
        nano_css = (css_server) ? n.create({ sh: css_server }) : n.create();
        n.rule(nano_css);
        n.sheet(nano_css);
        n.nesting(nano_css);
        n.hydrate(nano_css);
        n.unitless(nano_css);
        n.global(nano_css);
        n.keyframes(nano_css);
        n.fadeIn(nano_css);
        n.fadeOut(nano_css);
        Opal.global.NanoCSSInstance = nano_css;
      }
      Preact.create_context('LucidApplicationContext', { iso_store: Isomorfeus.store, nano_css: nano_css })
    end
  end
end
