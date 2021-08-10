### Using Preact Router
First the Components of Preact Router must be imported and made available in the global context:
```javascript
import * as PreactRouter from 'react-router';
import * as PreactRouterDOM from 'react-router-dom';
import { BrowserRouter, Link, NavLink, Route, Switch } from 'react-router-dom';

global.PreactRouter = PreactRouter;
global.PreactRouterDOM = PreactRouterDOM;
global.Router = BrowserRouter;
global.Link = Link;
global.NavLink = NavLink;
global.Route = Route;
global.Switch = Switch;
```
Only import whats needed, or import HashRouter instead of BrowserRouter.
Then the Router components can be used:
```ruby
class RouterComponent < Preact::Component::Base
  render do
    DIV do
      # The location prop is important for SSR when using StaticRouter:
      Router(location: props.location) do
        Switch do
          Route(path: '/my_path/:id', exact: true, render: component_fun('MyOtherComponent'))
          Route(path: '/', strict: true, render: component_fun('MyComponent', another_prop: 'test')) # <- passing additional prop
        end
      end
    end
  end
end
```
The `component_fun` method creates a small wrapper component that ensures the component constant is only autoloaded when actually being rendered.
In addition to that, it allows for passing additional props to the component, besides the react router props.

#### Props

The child components then get the Router props
(match, history, location) passed in their props. They can be accessed like this:
```ruby
class MyOtherComponent < Preact::Component::Base

  render do
    Sem.Container(text_align: 'left', text: true) do
      DIV do
        SPAN { 'match :id is: ' }
        SPAN { props.match.id }
      end
      DIV do
        SPAN { 'location pathname is: ' }
        SPAN { props.location.pathname }
      end
      DIV do
        SPAN { 'number of history entries: ' }
        SPAN { props.history.length }
      end
    end
  end
end
```
Otherwise the Preact Router documentation applies: https://reacttraining.com/react-router/

#### Server Side Rendering

For Server Side Rendering the StaticRouter must be used. Import:

```javascript
import { StaticRouter, Link, NavLink, Route, Switch } from 'react-router-dom';  
global.Router = StaticRouter;
```
