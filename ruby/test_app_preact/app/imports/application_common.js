// import javascript modules common to browser and server side rendering environments
import * as Redux from 'redux';
global.Redux = Redux;
import * as Preact from 'preact';
import * as PreactHooks from 'preact/hooks'
import { memo } from 'preact/compat';
global.Preact = Preact;
global.PreactHooks = PreactHooks;
global.Preact.memo = memo;
import * as ReactJSS from 'react-jss';
global.ReactJSS = ReactJSS;
import * as Formik from 'formik';
global.Formik = Formik;

if (module.hot) { module.hot.accept(); }
