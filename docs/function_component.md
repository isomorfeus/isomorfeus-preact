### Function Components
Function Components are created using a Ruby DSL that is used within the creator class. 
```ruby
class MyFunctionComponent < Preact::FunctionComponent::Base
  render do 
    SPAN { props.text }
  end
end
```

A Function Component can then be used in other Components:
```ruby
class MyComponent < Preact::Component::Base
  render do
    MyOtherComponent(text: 'some text')
    MyFunctionComponent(text: 'more text')
  end
end
```

**Data flow of a Preact::FunctionComponent:**
![Preact::FunctionComponent Data Flow](https://raw.githubusercontent.com/isomorfeus/isomorfeus-preact/master/images/data_flow_function_component.png)

#### Memo Components
To create a function component that renders only when props change, use the memo_component, which uses Preact.memo:
```ruby
class MyFunctionComponent < Preact::MemoComponent::Base
  # A custom function can be utilized to check if a render should happen
  props_are_equal? do |prev_props, next_props|
    prev_props != next_props
  end
  
  render do |props|
    SPAN { props.text }
  end
end
```

A custom memo props function can also be utilized when using Preact.memo directly with a function component and a block for checking the props:
```ruby
Preact.memo(`MyComponent`) do |prev_props, next_props|
  prev_props.var != next_props.var
end
```
#### Events
The event_handler DSL can be used within the Preact::FunctionComponent::Creator. However, function component dont react by themselves to events,
the event handler must be applied to a element.
```ruby
class MyFunctionComponent < Preact::FunctionComponent::Base
  def show_red_alert(event)
    `alert("RED ALERT!")`
  end

  def show_orange_alert(event)
    `alert("ORANGE ALERT!")`
  end

  render 'AFunComponent' do
    SPAN(on_click: props.on_click) { 'Click for orange alert! ' } # event handler passed in props, applied to a element
    SPAN(on_click: :show_red_alert) { 'Click for red alert! '  } # event handler directly applied to a element
  end
end
```

#### Hooks
##### useState -> use_state
```ruby
class MyFunctionComponent
  include Preact::FunctionComponent::Base
  
  render do
    value, set_value = use_state('nothinghere')
    handler = proc { |event| set_value.call('somethinghere') }
    DIV(id: :test_component, on_click: handler) { value }
  end
end
```
`use_state(name, initial_value)` - creates as setter method for the name given and calls Preact.useState for setting the initial value.

##### useEffect -> use_effect
```ruby
class MyFunctionComponent
  include Preact::FunctionComponent::Base
  render do
    use_effect do
      # show effect
    end
   
    SPAN { props.text }
  end
end
```

##### useContext -> use_context
```ruby
Preact.create_context('MyContext', 10)

class MyFunctionComponent
  include Preact::FunctionComponent::Base
  render do
    value = use_context(MyContext) 
   
    SPAN { props.text }
  end
end
```

##### Using Hooks from Imports
Hooks from imports can be directly used.
If for example Mui is imported with:
```javascript
import * as Mui from '@material-ui/core'
global.Mui = Mui;
```
then the useTheme Hook cen be used with:
```ruby
class MyFunctionComponent
  include Preact::FunctionComponent::Base
  render do
    theme = Mui.useTheme
    # or more ruby style
    theme = Mui.use_theme
```
