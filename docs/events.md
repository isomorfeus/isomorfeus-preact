### Events
Event names are underscored in ruby: `onClick` becomes `on_click`. The conversion for Preact is done automatically.

Events can be simple methods, but must be referenced when passed as prop by `method_ref`. This is to make sure,
that they are passed by reference during render to preact to prevent unnecessary renders.

Example:
```ruby
class MyComponent < Preact::Component::Base
  def handle_click(event, info)
    state.toggler = !state.toggler
  end

  render do
    SPAN(on_click: method_ref(:handle_click)) { 'some more text' }
    SPAN(on_click: method_ref(:handle_click)) { 'a lot more text' } # event handlers can be reused
  end
end
```
However, for the simple case, when no additional args are needed, method_refs are created automatically when passing the method name as symbol as event handler. Example:
```ruby
class MyComponent < Preact::Component::Base
  def handle_click(event, info)
    state.toggler = !state.toggler
  end

  render do
    SPAN(on_click: :handle_click) { 'some more text' } # causes creation of a method_ref internally
    SPAN(on_click: :handle_click) { 'a lot more text' } # event handlers is reused
  end
end
```

Some events pass a optional 'info' arg.

With explicit method_refs additional args can be passed to the event handler:
```ruby
class MyComponent < Preact::Component::Base
  def handle_click(event, info, arg)
    puts "#{arg}"
  end

  render do
    DIV(on_click: method_ref(:my_handler, "first DIV")) { 'ouch' }
    DIV(on_click: method_ref(:my_handler, "second DIV")) { 'nice' }
  end
end
```
Multiple args can be passed and are appended in order.

To the event handler the event is passed as argument. The event is a ruby object `Browser::Event` and supports all the methods, properties
and events as the Browser event. Methods are underscored. Example:
```ruby
class MyComponent < Preact::Component::Base
  def handle_click(event, info)
    event.prevent_default
    event.current_target
  end

  render do
    SPAN(on_click: method_ref(:handle_click)) { 'some more text' }
  end
end
```
Targets of the event, like current_target, are wrapped Elements as supplied by opal-browser.
Some events pass a optional 'info' arg.
