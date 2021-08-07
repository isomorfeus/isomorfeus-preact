module LucidApp
  module Api
    def self.included(base)
      base.instance_exec do
        def theme(theme_hash = nil, &block)
          if block_given?
            result = block.call(Preact::Component::Styles.new(`base.jss_theme`))
            %x{
              if (typeof result.$to_n === 'function') { base.jss_theme = result.$to_n(); }
              else { base.jss_theme = result; }
              return result;
            }
          elsif theme_hash
            `base.jss_theme = #{theme_hash.to_n}` if theme_hash
            theme_hash
          elsif `typeof base.jss_theme === 'object'`
            `Opal.Hash.$new(base.jss_theme)`
          else
            nil
          end
        end
        alias_method :theme=, :theme
      end
    end
  end
end
