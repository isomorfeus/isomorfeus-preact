### Server Side Rendering
SSR is turned on by default in production and in development. SSR is done in node using isomorfeus-speednode.
Components that depend on a browser can be shielded from rendering in node by using the execution environment helper methods:
- `on_browser?`
- `on_ssr?`

Example:
```ruby
class MyOtherComponent < Preact::Component::Base

  render do
    if on_browser?
      SomeComponentDependingOnWindow()
    else
      DIV()
    end
  end
end
```

In development, the url that is prefixed to the asset name used for ssr can be specified with:
```ruby
Isomorfeus.ssr_hot_asset_url = 'http://localhost:3036/assets/'
```
It must have a trailing '/'.

