// entry file for the server side rendering environment (ssr)

// import modules common to browser and server side rendering (ssr)
// environments from application_common.js
import './application_common.js';
// import npm modules that are only valid to use in the server side rendering environment
// for example modules which depend on objects provided by node js
import { renderToString } from 'preact-render-to-string';
global.Preact.renderToString = renderToString;
import { StaticRouter, Link, NavLink, Route, Switch } from 'react-router-dom';
// global.History = History;
global.Router = StaticRouter;
global.Link = Link;
global.NavLink = NavLink;
global.Route = Route;
global.Switch = Switch;

import init_app from 'isomorfeus_loader.rb';
init_app();
global.Opal.load('isomorfeus_loader');

if (module.hot) { module.hot.accept(); }
