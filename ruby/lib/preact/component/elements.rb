module Preact
  module Component
    module Elements
      # https://www.w3.org/TR/html52/fullindex.html#index-elements
      # https://www.w3.org/TR/SVG11/eltindex.html
      SUPPORTED_HTML_AND_SVG_ELEMENTS = %w[
        a abbr address area article aside audio
        b base bdi bdo blockquote body br button
        canvas caption cite code col colgroup
        data datalist dd del details dfn dialog div dl dt
        em embed
        fieldset figcaption figure footer form
        h1 h2 h3 h4 h5 h6 head header hr html
        i iframe img input ins
        kbd
        label legend li link
        main map mark meta meter
        nav noscript
        object ol optgroup option output
        p param picture pre progress
        q
        rp rt rtc ruby
        s samp script section select small source span strong style sub summary sup
        table tbody td template textarea tfoot th thead time title tr track
        u ul
        var video
        wbr
        altGlyph altGlyphDef altGlyphItem animate animateColor animateMotion animateTransform
        circle clipPath color-profile cursor
        defs desc
        ellipse
        feBlend feColorMatrix feComponentTransfer feComposite feConvolveMatrix feDiffuseLighting
        feDisplacementMap feDistantLight feFlood feFuncA feFuncB feFuncG feFuncR feGaussianBlur
        feImage feMerge feMergeNode feMorphology feOffset fePointLight feSpecularLighting
        feSpotLight feTile feTurbulence
        filter font font-face font-face-format font-face-name font-face-src font-face-uri foreignObject
        g glyph glyphRef
        hkern
        image
        line linearGradient
        marker mask metadata missing-glyph mpath
        path pattern polygon polyline
        radialGradient rect
        script set stop style svg switch symbol
        text textPath tref tspan
        use
        view vkern
      ]

      SUPPORTED_HTML_AND_SVG_ELEMENTS.each do |element|
        define_method(element) do |*args, &block|
          `Opal.Preact.internal_prepare_args_and_render(element, args, block)`
        end
        define_method(`element.toUpperCase()`) do |*args, &block|
          `Opal.Preact.internal_prepare_args_and_render(element, args, block)`
        end
      end
    end
  end
end
