module LucidApp
  module Api
    def self.included(base)
      base.instance_exec do
        def theme(theme_hash = nil, &block)
          theme_hash = block.call if block_given?
          if theme_hash
            component_name = self.to_s
            %x{
              let rule_name = component_name.replace(/:/g, '_');
              let ogni = Opal.global.NanoCSSInstance;
              if (base.css_theme && #{Isomorfeus.production?}) { return base.css_theme; }
              else if(#{Isomorfeus.development?}) {
                if (#{on_browser?}) {
                  ogni.delete_from_sheet(rule_name);
                  ogni.delete_from_rule_blocks(rule_name);
                  ogni.hydrate_force_put = true;
                }
              }
              if (typeof theme_hash.$is_wrapped_style !== 'undefined') {
                base.css_theme = theme_hash;
              } else {
                let css;
                if (typeof theme_hash.$to_n === 'function') { css = theme_hash.$to_n(); }
                else { css = theme_hash; }
                let nano_styles = ogni.sheet(css, rule_name);
                base.css_theme = #{::LucidComponent::StylesWrapper.new(`nano_styles`)};
              }
            }
          end
          %x{
            if (!base.css_theme) { return nil; }
            return base.css_theme;
          }
        end
        alias_method :theme=, :theme
      end
    end
  end
end
