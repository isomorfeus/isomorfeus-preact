### Using Wouter as Router
Wouter comes integratedwith isomorfeus-preact. The wouter documentation applies, see [https://github.com/molefrog/wouter](https://github.com/molefrog/wouter)
```ruby
class RouterComponent < Preact::Component::Base
  render do
    DIV do
      # The location hook is important for SSR, its automatically selected:
      Router(hook: Preact.location_hook(props.location)) do
        Switch do
          Route(path: '/', component: HelloComponent.to_js)
          Route(path: '/my_path/:id',  component: MyOtherComponent.to_js)
        end
      end
    end
  end
end
```

Any ruby components javascript equivalent can be accessed directly from the ruby constant with `RubyConstant.to_js` or `RubyConstant.JS[:preact_component]`.

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
