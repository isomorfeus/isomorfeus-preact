module LucidComponent
  module StylesApi
    def self.included(base)
      base.instance_exec do
        def styles(styles_hash = nil, &block)
          component_name = self.to_s
          styles_hash = block.call if block_given?
          if styles_hash
            %x{
              if (typeof styles_hash.$is_wrapped_style !== 'undefined') {
                base.css_styles = styles_hash;
              } else {
                let css;
                if (typeof styles_hash.$to_n === 'function') { css = styles_hash.$to_n(); }
                else { css = styles_hash; }
                let nano_styles = Opal.global.NanoCSSInstance.sheet(css, component_name.replace(/:/g, '_'));
                base.css_styles = #{::LucidComponent::StylesWrapper.new(`nano_styles`)};
              }
            }
          end
          `base.css_styles`
        end
        alias_method :styles=, :styles
      end

      def styles
        `self.$class().css_styles`
      end
    end
  end
end
