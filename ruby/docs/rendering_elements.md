### Rendering HTML or SVG Elements
Elements are rendered using a DSL which provides all Elements supported by Preact following these specs:
- https://www.w3.org/TR/html52/fullindex.html#index-elements
- https://www.w3.org/TR/SVG11/eltindex.html

The DSL can be used like so:
```ruby
class MyComponent < Preact::Component::Base
  render do
    SPAN { 'some more text' } # upper case
    span { 'so much text' } # lower case
  end
end
```
Use whichever you prefer. There are some clashes with opal ruby kernel methods, like `p 'text'`, that may have to be considered.
