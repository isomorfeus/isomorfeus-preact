### Using Wouter as Router
First the Components of Wouter must be imported and made available in the global context:
```javascript
import { Router, Link, Redirect, Route, Switch } from 'wouter-preact';
global.Router = Router;
global.Link = Link;
global.Redirect = Redirect;
global.Route = Route;
global.Switch = Switch;
```
Then the Router components can be used:
```ruby
class RouterComponent < Preact::Component::Base
  render do
    DIV do
      # The location hook is important for SSR, its automatically selected:
      Router(hook: Preact.location_hook(props.location)) do
        Switch do
          Route(path: '/', component: HelloComponent.JS[:preact_component])
          Route(path: '/my_path/:id',  component: MyOtherComponent.JS[:preact_component])
        end
      end
    end
  end
end
```

Any ruby components javascript equivalent can be accessed directly from the ruby constant with `RubyConstant.JS[:preact_component]`.

#### Props

The child components then get the Router props (params) passed in their props. From the example above, the second route with ':id', they can be accessed like this:
```ruby
class MyOtherComponent < Preact::Component::Base

  render do
    Sem.Container(text_align: 'left', text: true) do
      DIV do
        SPAN { 'matched :id is: ' }
        SPAN { props.params.id }
      end
    end
  end
end
```
