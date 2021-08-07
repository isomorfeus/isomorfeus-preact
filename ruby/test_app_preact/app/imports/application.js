// entry file for the browser environment
// import stylesheets here
var start = new Date();
import '../styles/application.css';

// import npm modules that are valid to use only in the browser
import { BrowserRouter, Link, NavLink, Route, Switch } from 'react-router-dom';
// global.History = History;
global.Router = BrowserRouter;
global.Link = Link;
global.NavLink = NavLink;
global.Route = Route;
global.Switch = Switch;
// import modules common to browser and server side rendering (ssr)
// environments from application_common.js
import './application_common.js';

import init_app from 'isomorfeus_loader.rb';
init_app();
Opal.load('isomorfeus_loader');
Opal.Object.$const_set('APP_LOAD_TIME', (new Date()) - start);

if (module.hot) { module.hot.accept(); }
