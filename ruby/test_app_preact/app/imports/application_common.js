// import javascript modules common to browser and server side rendering environments
import * as Redux from 'redux';
global.Redux = Redux;
import * as Preact from 'preact';
import * as PreactHooks from 'preact/hooks'
global.Preact = Preact;
global.PreactHooks = PreactHooks;
import * as ReactJSS from 'react-jss';
global.ReactJSS = ReactJSS;
import * as Formik from 'formik';
global.Formik = Formik;

if (module.hot) { module.hot.accept(); }
