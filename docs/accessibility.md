### Accessibility
Props like `aria-label` must be written underscored `aria_label`. They are automatically converted for Preact. Example:
```ruby
class MyComponent < Preact::Component::Base
  render do
    SPAN(aria_label: 'label text') { 'some more text' }
  end
end
```
