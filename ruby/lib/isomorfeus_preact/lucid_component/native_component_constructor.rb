module LucidComponent
  module NativeComponentConstructor
    # for should_component_update we apply ruby semantics for comparing props
    # to do so, we convert the props to ruby hashes and then compare
    # this makes sure, that for example rubys Nil object gets handled properly
    def self.extended(base)
      component_name = base.to_s + 'Wrapper'
      # language=JS
      %x{
        base.preact_component = function(props) {
          let opag = Opal.global;
          let classes;
          let store;
          if (base.store_updates) { store = opag.PreactHooks.useContext(opag.LucidApplicationContext); }
          let theme = opag.ReactJSS.useTheme();
          if (base.jss_styles) {
            if (!base.use_styles || (Opal.Isomorfeus.development === true)) {
              let styles;
              if (typeof base.jss_styles === 'function') { styles = base.jss_styles(theme); }
              else { styles = base.jss_styles; }
              base.use_styles = opag.ReactJSS.createUseStyles(styles);
            }
            classes = base.use_styles();
          }
          let new_props = Object.assign({}, props)
          new_props.classes = classes;
          new_props.theme = theme;
          new_props.store = store;
          return opag.Preact.createElement(base.lucid_preact_component, new_props);
        };
        base.preact_component.displayName = #{component_name};
      }
    end
  end
end
