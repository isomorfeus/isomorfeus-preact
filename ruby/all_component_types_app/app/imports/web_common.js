// import javascript modules common to browser and server side rendering environments
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

if (module.hot) { module.hot.accept(); }
