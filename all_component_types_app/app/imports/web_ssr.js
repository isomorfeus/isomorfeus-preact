// entry file for the server side rendering environment (ssr)

// import modules common to browser and server side rendering (ssr)
// environments from application_common.js
import './web_common.js';
// import npm modules that are only valid to use in the server side rendering environment
// for example modules which depend on objects provided by node js
import { renderToString } from 'preact-render-to-string';
global.Preact.renderToString = renderToString;
import staticLocationHook from 'wouter-preact/static-location';
global.staticLocationHook = staticLocationHook;
import WebSocket from 'ws';
global.WebSocket = WebSocket;

import init_app from 'web_loader.rb';
init_app();
global.Opal.load('web_loader');

if (module.hot) { module.hot.accept(); }
