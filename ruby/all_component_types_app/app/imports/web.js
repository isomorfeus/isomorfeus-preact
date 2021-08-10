// entry file for the browser environment
// import stylesheets here
import '../styles/web.css';

// import npm modules that are valid to use only in the browser
import locationHook from 'wouter-preact/use-location';
global.locationHook = locationHook;
import deepForceUpdate from 'preact-deep-force-update'
global.deepForceUpdate = deepForceUpdate;
// import modules common to browser and server side rendering (ssr)
// environments from application_common.js
import './web_common.js';

import init_app from 'web_loader.rb';
init_app();
Opal.load('web_loader');

if (module.hot) { module.hot.accept(); }
