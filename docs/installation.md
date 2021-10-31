## Installation
### Dependencies

For full functionality the following are required:

Ruby Gems:

- [Opal with ES6 modules](https://github.com/opal/opal/pull/2266)
- [Opal-Zeitwerk Autoloader](https://github.com/isomorfeus/opal-zeitwerk)

For the Gemfile:
```ruby
gem 'opal', '~> 1.3.0'
gem 'isomorfeus-preact', '~> 10.5.10'
```

Required Javascript Npms:

#### Preact
- preact
- preact-render-to-string for server side rendering
- preact-deep-force-update for refreshing the render tree after hot module reloading
- opal-webpack-loader
- wouter for routing
- redux
- nano-css for LucidComponent styling support, required when using LucidComponents

For package.json:
```json
    "preact": "^10.5.14",
    "preact-render-to-string": "^5.1.19",
    "nano-css": "^5.3.4",
    "wouter-preact": "^2.7.4",
    "redux": "^4.1.0"
```

Then the usual:
- `yarn install`
- `bundle install`

### Importing Javascript Dependencies
Preact, Redux and accompanying libraries must be imported and made available in the global namespace in the application javascript entry file. With webpack this can be ensured by assigning them to the global namespace:

Common imports:
```javascript
import * as Redux from 'redux';
global.Redux = Redux;
import * as Preact from 'preact';
global.Preact = Preact;
import * as PreactHooks from 'preact/hooks'
global.PreactHooks = PreactHooks;
import { Router, Link, Redirect, Route, Switch } from 'wouter-preact';
global.Router = Router;
global.Link = Link;
global.Redirect = Redirect;
global.Route = Route;
global.Switch = Switch;
import * as NanoCSS from 'nano-css';
global.NanoCSS = NanoCSS;
import { addon as NanoCSSAddOnRule } from 'nano-css/addon/rule';
import { addon as NanoCSSAddOnSheet } from 'nano-css/addon/sheet';
import { addon as NanoCSSAddOnNesting } from 'nano-css/addon/nesting';
import { addon as NanoCSSAddOnHydrate } from 'nano-css/addon/hydrate';
import { addon as NanoCSSAddOnUnitless } from 'nano-css/addon/unitless';
import { addon as NanoCSSAddOnGlobal } from 'nano-css/addon/global';
import { addon as NanoCSSAddOnKeyframes } from 'nano-css/addon/keyframes';
import { addon as NanoCSSAddOnAnimateFadeIn } from 'nano-css/addon/animate/fadeIn';
import { addon as NanoCSSAddOnAnimateFadeOut } from 'nano-css/addon/animate/fadeOut';
global.NanoCSSAddOns = {
  rule: NanoCSSAddOnRule,
  sheet: NanoCSSAddOnSheet,
  nesting: NanoCSSAddOnNesting,
  hydrate: NanoCSSAddOnHydrate,
  unitless: NanoCSSAddOnUnitless,
  global: NanoCSSAddOnGlobal,
  keyframes: NanoCSSAddOnKeyframes,
  fade_in: NanoCSSAddOnAnimateFadeIn,
  fade_out: NanoCSSAddOnAnimateFadeOut
};
```

Imports for the browser:
```javascript
import locationHook from 'wouter-preact/use-location';
global.locationHook = locationHook;
```

Imports for server side rendering:
```javascript
import { renderToString } from 'preact-render-to-string';
global.Preact.renderToString = renderToString;
import staticLocationHook from 'wouter-preact/static-location';
global.staticLocationHook = staticLocationHook;
```

Loading the opal code:
```ruby
require 'isomorfeus-preact'
```
