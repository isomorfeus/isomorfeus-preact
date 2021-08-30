module LucidApp
  module Api
    def self.included(base)
      base.instance_exec do
        def theme(theme_hash = nil, &block)
          theme_hash = block.call if block_given?
          if theme_hash
            %x{
              let css;
              if (typeof theme_hash.$to_n === 'function') { css = theme_hash.$to_n(); }
              else { css = theme_hash; }
              let nano_styles = Opal.global.NanoCSSInstance.sheet(css, "LucidAppTheme");
              base.css_theme = #{::LucidComponent::StylesWrapper.new(`nano_styles`)};
            }
          end
          `base.css_theme`
        end
        alias_method :theme=, :theme
      end
    end
  end
end
