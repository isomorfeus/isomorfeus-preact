### Render blocks
render or element or component blocks work like ruby blocks, the result of the last expression in a block is returned and then rendered,
but only if it is a string or a Preact Element.
HTML Elements and Components at any place in the blocks are rendered too.
Examples:
```ruby
class MyComponent < Preact::Component::Base
  render do
    SPAN { "string" } # this string is rendered in a SPAN HTML Element
    SPAN { "another string" } # this string is rendered in a SPAN too
  end
end
```
```ruby
class MyComponent < Preact::Component::Base
  render do
    "string" # this string is NOT rendered, its not returned from the block and its not wrapped in a Element,
             # to render it, wrap it in a element or fragment
    "another string" # this string is returned from the block, so its rendered
  end
end
```
```ruby
class MyComponent < Preact::Component::Base
  render do
    Fragment { "string" } # this string is rendered without surrounding element
    100 # this is not a string, so its NOT rendered, to render it, simply convert it to a string: "#{100}" or 100.to_s
  end
end
```
There is a shorthand "string param syntax". Its advantages are:
- reduced asset size, because it reduces the amount of compiled blocks, strings are passed as param instead
- improved performance, because it reduces the amount of executed blocks, strings are passed as param instead

Its disadvantages are:
- it looks a bit odd when other params are passed

The first render block example in "string param syntax":
```ruby
class MyComponent < Preact::Component::Base
  render do
    SPAN "string" # this string is rendered in a SPAN HTML Element, short and handy
    SPAN "another string" # this string is rendered in a SPAN too, short and handy
    
    # "string param syntax" with additional params:
    SPAN({class: 'design'}, "yet another string") # <- not recommended
    # for comparison the "string block syntax" with additonal params
    SPAN(class: 'design') { 'even a string' }     # <- recommended, looks better
  end
end
```

Also &nbsp\; doesn't work in strings, instead "\u00A0" must be used.

### Passing Preact Elements of Ruby Components via property

Some Javascript components accept a Preact Element as property. To get the Preact element for a component use `get_preact_element`:
```ruby
element = get_preact_element do
  Mui.Hidden(sm_down: true) { 'Timeline' }
end
# then pass the element
Mui.Tab(label: element)
# or reuse it later again
Mui.Tab(label: element)
```

### Direct Rendering of Preact Elements
Native Preact Elements can be directly rendered: 
```ruby
class Working < Preact::Component::Base
  render do
    # element passed in props
    el = props.element 
    # render the element
    render_preact_element(el)

    # or create a element
    element = get_preact_element do
      Mui.Hidden(sm_down: true) { 'Timeline' }
    end
    # and render it 5 times:
    5.times do
      render_preact_element(element)
    end
  end
end
```

### Passing Procs and Ruby methods in props
Though possible its not recommended to pass procs in props. Passing procs in props will cause unnecessary renders.
Instead its best to pass methods by reference using `method_ref`. Example:
```ruby
class AnotherComponent < Preact::Component::Base
  render do
    props.passed_method.call(2)
  end
end

class BestWay < Preact::Component::Base
  def a_method(count)
    count.times do
      DIV 'yeah'
    end
  end

  render do
     AnotherComponent(passed_method: method_ref(:a_method))
  end
end
```
There is a shortcut for `method_ref`: `m_ref`.

