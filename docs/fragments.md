### Fragments
Fragments can be created like so:
```ruby
class MyComponent < Preact::Component::Base
  render do
    Fragment do
      SPAN { 'useful text' }
      SPAN { 'extremely useful text' }
    end
  end
end
```
