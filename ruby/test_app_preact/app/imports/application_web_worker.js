// import modules for webworkers
import init_app from 'isomorfeus_web_worker_loader.rb';
init_app();
Opal.load('isomorfeus_web_worker_loader');

if (module.hot) { module.hot.accept(); }
