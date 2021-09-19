module NanoCSS
  %x{
    var KEBAB_REGEX = /[A-Z]/g;

    function hash(str) {
      var h = 5381, i = str.length;
      while (i) h = (h * 33) ^ str.charCodeAt(--i);
      return '_' + (h >>> 0).toString(36);
    };
  }

  %x{
    self.create = function (config) {
      config = config || {};
      var assign = config.assign || Object.assign;
      var client = typeof window === 'object';

      // Check if we are really in browser environment.
      if (process.env.NODE_ENV !== 'production') {
        if (client) {
          if ((typeof document !== 'object') || !document.getElementsByTagName('HTML')) {
            console.error('nano-css detected browser environment because of "window" global, but "document" global seems to be defective.');
          }
        }
      }

      var renderer = assign({
        raw: '',
        pfx: '_',
        client: client,
        assign: assign,
        stringify: JSON.stringify,
        kebab: function (prop) {
          return prop.replace(KEBAB_REGEX, '-$&').toLowerCase();
        },
        decl: function (key, value) {
          key = renderer.kebab(key);
          return key + ':' + value + ';';
        },
        hash: function (obj) { return hash(renderer.stringify(obj)); },
        selector: function (parent, selector) {
          return parent + (selector[0] === ':' ? ''  : ' ') + selector;
        },
        putRaw: function (rawCssRule) { renderer.raw += rawCssRule; }
      }, config);

      if (renderer.client) {
        if (!renderer.sh) { document.head.appendChild(renderer.sh = document.createElement('style')); }

        if (process.env.NODE_ENV !== 'production') {
          renderer.sh.setAttribute('data-nano-css-dev', '');

          // Test style sheet used in DEV mode to test if .insetRule() would throw.
          renderer.shTest = document.createElement('style');
          renderer.shTest.setAttribute('data-nano-css-dev-tests', '');
          document.head.appendChild(renderer.shTest);
        }

        renderer.putRaw = function (rawCssRule) {
          // .insertRule() is faster than .appendChild(), that's why we use it in PROD.
          // But CSS injected using .insertRule() is not displayed in Chrome Devtools,
          // that's why we use .appendChild in DEV.
          if (process.env.NODE_ENV === 'production') {
            var sheet = renderer.sh.sheet;

            // Unknown pseudo-selectors will throw, this try/catch swallows all errors.
            try { sheet.insertRule(rawCssRule, sheet.cssRules.length); } 
            catch (error) {}
          } else {
            // Test if .insertRule() works in dev mode. Unknown pseudo-selectors will throw when
            // .insertRule() is used, but .appendChild() will not throw.
            try {
              renderer.shTest.sheet.insertRule(rawCssRule, renderer.shTest.sheet.cssRules.length);
            } catch (error) {
              if (config.verbose) {
                console.error(error);
              }
            }

            // Insert pretty-printed CSS for dev mode.
            renderer.sh.appendChild(document.createTextNode(rawCssRule));
          }
        };
      }

      renderer.put = function (selector, decls, atrule) {
        var str = '';
        var prop, value;
        var postponed = [];

        for (prop in decls) {
          value = decls[prop];

          if ((value instanceof Object) && !(value instanceof Array)) {
            postponed.push(prop);
          } else {
            if ((process.env.NODE_ENV !== 'production') && !renderer.sourcemaps) {
              str += '    ' + renderer.decl(prop, value, selector, atrule) + '\n';
            } else {
              str += renderer.decl(prop, value, selector, atrule);
            }
          }
        }

        if (str) {
          if ((process.env.NODE_ENV !== 'production') && !renderer.sourcemaps) {
            str = '\n' + selector + ' {\n' + str + '}\n';
          } else {
            str = selector + '{' + str + '}';
          }
          renderer.putRaw(atrule ? atrule + '{' + str + '}' : str);
        }

        for (var i = 0; i < postponed.length; i++) {
          prop = postponed[i];

          if (prop[0] === '@' && prop !== '@font-face') {
            renderer.putAt(selector, decls[prop], prop);
          } else {
            renderer.put(renderer.selector(selector, prop), decls[prop], atrule);
          }
        }
      };

      renderer.putAt = renderer.put;

      return renderer;
    };
  }   
  
  # addons

  %x{
    self.rule = function (renderer) {
      var blocks;
      if (process.env.NODE_ENV !== 'production') {
          blocks = {};
      }
  
      renderer.rule = function (css, block) {
          // Warn user if CSS selectors clash.
          if (process.env.NODE_ENV !== 'production') {
              if (block) {
                  if (typeof block !== 'string') {
                      throw new TypeError(
                          'nano-css block name must be a string. ' +
                          'For example, use nano.rule({color: "red", "RedText"}).'
                      );
                  }
  
                  if (blocks[block]) {
                      console.error('Block name "' + block + '" used more than once.');
                  }
  
                  blocks[block] = 1;
              }
          }
  
          block = block || renderer.hash(css);
          block = renderer.pfx + block;
          renderer.put('.' + block, css);
  
          return ' ' + block;
      };
    };
  }

  %x{
    self.sheet = function (renderer) { 
      renderer.sheet = function (map, block) {
        var result = {};
  
        if (!block) {
          block = renderer.hash(map);
        }
  
        var onElementModifier = function (elementModifier) {
          var styles = map[elementModifier];
  
          if ((process.env.NODE_ENV !== 'production') && renderer.sourcemaps) {
            // In dev mode emit CSS immediately to generate sourcemaps.
            result[elementModifier] = renderer.rule(styles, block + '-' + elementModifier);
          } else {
            Object.defineProperty(result, elementModifier, {
              configurable: true,
              enumerable: true,
              get: function () {
                var classNames = renderer.rule(styles, block + '-' + elementModifier);
  
                Object.defineProperty(result, elementModifier, {
                  value: classNames,
                  enumerable: true
                });
  
                return classNames;
              },
            });
          }
        };
  
        for (var elementModifier in map) {
          onElementModifier(elementModifier);
        }
  
        return result;
      };
    };
  }

  %x{
    self.nesting = function (renderer) {
      renderer.selector = function (parentSelectors, selector) {
        var parents = parentSelectors.split(',');
        var result = [];
        var selectors = selector.split(',');
        var len1 = parents.length;
        var len2 = selectors.length;
        var i, j, sel, pos, parent, replacedSelector;
  
        for (i = 0; i < len2; i++) {
          sel = selectors[i];
          pos = sel.indexOf('&');
  
          if (pos > -1) {
            for (j = 0; j < len1; j++) {
              parent = parents[j];
              replacedSelector = sel.replace(/&/g, parent);
              result.push(replacedSelector);
            }
          } else {
            for (j = 0; j < len1; j++) {
              parent = parents[j];
  
              if (parent) {
                result.push(parent + ' ' + sel);
              } else {
                result.push(sel);
              }
            }
          }
        }
  
        return result.join(',');
      };
    };
  }

  %x{
    self.hydrate = function (renderer) {
      var hydrated = {};
  
      renderer.hydrate = function (sh) {
        var cssRules = sh.cssRules || sh.sheet.cssRules;
  
        for (var i = 0; i < cssRules.length; i++)
          hydrated[cssRules[i].selectorText] = 1;
      };
  
      if (renderer.client) {
        if (renderer.sh) renderer.hydrate(renderer.sh);
  
        var put = renderer.put;
  
        renderer.put = function (selector, css) {
          if (selector in hydrated) return;
  
          put(selector, css);
        };
      }
    };
  }
  
  %x{
    var UNITLESS_NUMBER_PROPS = [
      'animation-iteration-count',
      'border-image-outset',
      'border-image-slice',
      'border-image-width',
      'box-flex',
      'box-flex-group',
      'box-ordinal-group',
      'column-count',
      'columns',
      'flex',
      'flex-grow',
      'flex-positive',
      'flex-shrink',
      'flex-negative',
      'flex-order',
      'grid-row',
      'grid-row-end',
      'grid-row-span',
      'grid-row-start',
      'grid-column',
      'grid-column-end',
      'grid-column-span',
      'grid-column-start',
      'font-weight',
      'line-clamp',
      'line-height',
      'opacity',
      'order',
      'orphans',
      'tabSize',
      'widows',
      'z-index',
      'zoom',
  
      // SVG-related properties
      'fill-opacity',
      'flood-opacity',
      'stop-opacity',
      'stroke-dasharray',
      'stroke-dashoffset',
      'stroke-miterlimit',
      'stroke-opacity',
      'stroke-width',
    ];
    
    var unitlessCssProperties = {};
    
    for (var i = 0; i < UNITLESS_NUMBER_PROPS.length; i++) {
      var prop = UNITLESS_NUMBER_PROPS[i];
    
      unitlessCssProperties[prop] = 1;
      unitlessCssProperties['-webkit-' + prop] = 1;
      unitlessCssProperties['-ms-' + prop] = 1;
      unitlessCssProperties['-moz-' + prop] = 1;
      unitlessCssProperties['-o-' + prop] = 1;
    }
    
    self.unitless = function (renderer) {
      var decl = renderer.decl;
  
      renderer.decl = function (prop, value) {
        var str = decl(prop, value);
  
        if (typeof value === 'number') {
          var pos = str.indexOf(':');
          var propKebab = str.substr(0, pos);
  
          if (!unitlessCssProperties[propKebab]) {
            return decl(prop, value + 'px');
          }
        }
  
        return str;
      };
    };
  }

  %x{
    self.global = function (renderer) {
      var selector = renderer.selector;
  
      renderer.selector = function (parent, current) {
        if (parent.indexOf(':global') > -1) parent = '';
  
        return selector(parent, current);
      };
  
      renderer.global = function (css) {
        return renderer.put('', css);
      };
    };
  }

  %x{
    self.keyframes = function (renderer, config) { 
      config = renderer.assign({
        prefixes: ['-webkit-', '-moz-', '-o-', ''],
      }, config || {});
  
      var prefixes = config.prefixes;
  
      if (renderer.client) {
        // Craete @keyframe Stylesheet `ksh`.
        document.head.appendChild(renderer.ksh = document.createElement('style'));
      }
  
      var putAt = renderer.putAt;
  
      renderer.putAt = function (__, keyframes, prelude) {
        // @keyframes
        if (prelude[1] === 'k') {
          var str = '';
  
          for (var keyframe in keyframes) {
            var decls = keyframes[keyframe];
            var strDecls = '';
  
            for (var prop in decls)
              strDecls += renderer.decl(prop, decls[prop]);
  
            str += keyframe + '{' + strDecls + '}';
          }
  
          for (var i = 0; i < prefixes.length; i++) {
            var prefix = prefixes[i];
            var rawKeyframes = prelude.replace('@keyframes', '@' + prefix + 'keyframes') + '{' + str + '}';
  
            if (renderer.client) {
              renderer.ksh.appendChild(document.createTextNode(rawKeyframes));
            } else {
              renderer.putRaw(rawKeyframes);
            }
          }
  
          return;
        }
  
        putAt(__, keyframes, prelude);
      };
  
      renderer.keyframes = function (keyframes, block) {
        if (!block) block = renderer.hash(keyframes);
          block = renderer.pfx + block;
  
        renderer.putAt('', keyframes, '@keyframes ' + block);
  
        return block;
      };
    };
  }

  %x{
    self.fadeIn = function (renderer) {
      renderer.put('', {
        '@keyframes fadeIn': {
          from: {
            opacity: 0,
          },
          to: {
            opacity: 1,
          }
        },
  
        '.fadeIn': {
          animation: 'fadeIn .4s linear',
        }
      });
    };
  }

  %x{
    self.fadeOut = function (renderer) {
      renderer.put('', {
        '@keyframes fadeOut': {
          from: {
            opacity: 1,
          },
          to: {
            opacity: 0,
          }
        },
  
        '.fadeOut': {
          animation: 'fadeOut .3s linear',
          'animation-fill-mode': 'forwards',
        }
      });
    };
  }
end