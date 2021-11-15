<h1 align="center">
  <img src="https://github.com/isomorfeus/isomorfeus-preact/blob/master/Logo.png?raw=true" align="center" width="234" height="125" />
  <br/>
  Isomorfeus Preact<br/>
</h1>

Develop Preact components for Opal Ruby along with very easy to use and advanced Preact-Redux Components.

## Community and Support
At the [Isomorfeus Framework Project](http://isomorfeus.com)

## Versioning and Compatibility
isomorfeus-preact version follows the Preact version which features and API it implements.

### Preact
Isomorfeus-preact 10.5.x implements features and the API of Preact 10.5.y and should be used with Preact 10.5.y

## Documentation

Because isomorfeus-preact follows closely the Preact principles/implementation/API and Documentation, most things of the official Preact documentation
apply, but in the Ruby way, see:
- [https://preactjs.com/guide/v10/getting-started](https://preactjs.com/guide/v10/getting-started)

Component Types:
- [Class Component](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/class_component.md)
- [Function and Memo Component](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/function_component.md)
- [Lucid App, Lucid Component](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/lucid_component.md)
- [Lucid Func (for use with Hooks)](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/lucid_func_component.md)
- [Preact Javascript Components and Preact Elements](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/javascript_component.md)

Which component to use?
- Usually LucidApp and LucidComponent.

Specific to Class, Lucid and LucidMaterial Components:
- [Events](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/events.md)
- [Lifecycle Callbacks](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/lifecycle_callbacks.md)
- [Props](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/props.md)
- [State](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/state.md)

For all Components:
- [Accessibility](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/accessibility.md)
- [Render Blocks](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/render_blocks.md)
- [Rendering HTML or SVG Elements](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/rendering_elements.md)

Special Preact Features:
- [Context](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/context.md)
- [Fragments](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/fragments.md)
- [Refs](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/refs.md)

Other Features:
- [Hot Module Reloading](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/hot_module_reloading.md)
- [Server Side Rendering](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/server_side_rendering.md)
- [Using Wouter as Router](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/wouter.md)
- [Isomorfeus Helpers](https://github.com/isomorfeus/isomorfeus-preact/blob/master/ruby/docs/isomorfeus_helpers.md)

### Development Tools
The Preact Devtools allow for analyzing, debugging and profiling components. A very helpful toolset and working very nice with isomorfeus-preact:
[https://preactjs.github.io/preact-devtools/](https://preactjs.github.io/preact-devtools/)

### Specs and Benchmarks
- clone repo
- `bundle install`
- `rake`
