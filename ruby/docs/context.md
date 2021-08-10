### Context
A context can be created using `Preact.create_context(constant_name, default_value)`. Constant_name must be a string like `"MyContext"`.
The context withs its Provider and Consumer can then be used like a component:
```ruby
Preact.create_context("MyContext", 'div')

class MyComponent < Preact::Component::Base
  render do
    MyContext.Provider(value: "span") do
      MyOtherComponent()
    end
  end
end
```
or the consumer:
```ruby
class MyOtherComponent < Preact::Component::Base
  render do
    MyContext.Consumer do |value|
      Sem.Button(as: value) { 'useful text' }
    end
  end
end
```
