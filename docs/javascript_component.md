### Preact Javascript Components

Native Preact Javascript Components must be available in the global namespace. When importing them with webpack
this can be ensured by assigning them to the global namespace:
```javascript
import * as Sem from 'semantic-ui-preact'
global.Sem = Sem;
```
They can then be used like so:
```ruby
class MyComponent < Preact::Component::Base
  render do
    Sem.Button(as: 'a') { 'useful text' }
  end
end
```

Some Javascript components accept another Javascript component as property, like for example Preact Router. The Ruby class won't work here,
instead the Javascript Preact component of the Ruby class must be passed.
It can be accessed by using Opals JS syntax to get the Preact Component of the Ruby class:
```ruby
Route(path: '/', strict: true, component: MyComponent.JS[:react_component])
```

Native Javascript components can be passed using the Javascript inlining of Opal, this also works for function components.
But for Server Side Rendering there is no global `window` Object to which all javascript constants get added, instead the global context must
be explicitly referred to:
```ruby
Route(path: '/a_button', strict: true, component: `Opal.global.Sem.Button`)
```
Accessing javascript constants via `Opal.global` makes sure they are available in the Browser and Server Side Rendering environment.
