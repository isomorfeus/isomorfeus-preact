// entry file for the browser environment
// import stylesheets here
var start = new Date();

// import npm modules that are valid to use only in the browser
import locationHook from 'wouter-preact/use-location';
global.locationHook = locationHook;
// import modules common to browser and server side rendering (ssr)
// environments from application_common.js
import './application_common.js';

import init_app from 'isomorfeus_loader.rb';
init_app();
Opal.load('isomorfeus_loader');
Opal.Object.$const_set('APP_LOAD_TIME', (new Date()) - start);

if (module.hot) { module.hot.accept(); }
