### Refs
Refs must be declared using the `ref` DSL. This is to make sure, that they are not recreated during render and can be properly
compared by reference by shouldComponentUpdate(). Use the DSL like so:
```ruby
class MyComponent < Preact::Component::Base
  ref :my_ref # a simple ref
  ref :my_other_ref do |element|  # a ref with block
    element.type
  end
  
  def report_ref(event)
    my_ref = ruby_ref(:my_ref) # ruby_ref() returns a ruby Preact::Ref object
    my_ref.current # is the element or component of this ref
    # if its a dom element a Browser::DOM::Element will be returned
    # if its a ruby component, its instance will be returned
    # if its a native component, its native instance will be returned 
  end
  
  render do
    # ref() returns the native ref object, or the function/block
    SPAN(ref: ref(:my_ref)) { 'useful text' } # refs can then be passed as prop
    SPAN(ref: ref(:my_other_ref)) { 'something' }
  end
end
```
