### Execution Environment
Code can run in 3 different environments:
- On the Browser, for normal execution
- On nodejs, for server side rendering
- On the server, for normal execution of server side code

The following helpers are available to determine the execution environment:
- `Isomorfeus.on_browser?` - true if running on the browser, otherwise false
- `Isomorfeus.on_ssr?` - true if running on node for server side rendering, otherwise false
- `Isomorfeus.on_server?` - true if running on the server, otherwise false

### View helpers
The view helpers module can be included in any class:
```ruby
class MyClass
  include Isomorfeus::PreactViewHelpers
end
```

The following view helpers are available:

- `mount_component(component_class_name, component_props, ssr_asset)` - mounts a component and returns the hydrated html tree for consumption
 by Preact on the client
- `cached_mount_component(component_class_name, component_props, ssr_asset)` - mounts a component and returns the hydrated html tree for consumption
 by Preact on the client. The tree is cached so the component code is executed only once.
- `mount_static_component(component_class_name, component_props, ssr_asset)` - mounts a component and returns the rendered html tree as static html
 string. The result cannot be used by Preact on the client.
- `cached_mount_static_component(component_class_name, component_props, ssr_asset)` - mounts a component and returns the rendered html tree as static html
 string. The result cannot be used by Preact on the client. The tree is cached so the component code is executed only once.
- `ssr_response_status` - returns the HTTP response status as returned by the last execution of any of the above mount helpers.
- `ssr_styles` - returns the stylesheets as returned by the last execution of any of the above mount helpers.
