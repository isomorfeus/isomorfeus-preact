### LucidMaterial::App andd LucidMaterial::Component
To use the MaterialUI support, it must be explicitly required in the opal code loader:
```ruby
require 'isomorfeus-react-material-ui'
```
Also the MaterialUI imports must be present, see the installation.md doc.

LucidMaterial::App and LucidMaterial::Component works just like LucidApp and LucidComponent and provide support for styling.
```ruby
class MyApp < LucidMaterial::App::Base # is a React::Context provider
  # LucidMaterial::App can provide a styles theme, it can be referred to by the LucidMaterial::Component styles DSL, see below
  # For the Mui Components to work, the default theme must be used:
  theme do |default_theme|
    default_theme.deep_merge!({ master: { width: 200 }})
  end

  render do
    Router do
      Switch do
        Route(path: '/', exact: true, component: MyComponent.JS[:react_component])
      end
    end
  end
end

class MyComponent < LucidMaterial::Component::Base # is a React::Context Consumer
  # styles can be set using a block that returns a hash, the theme gets passed to the block as hash:
  styles do |theme|
    { root: {
        width: theme.master.width,
        height: 100
    }}
  end

  # or styles can be set using a hash:
  styles(root: { width: 100, height: 100 })

  # a component may refer to some other components styles, if those are given as hash.
  # If the other components styles are given as block, that wont work.
  styles(OtherComponent.styles.deep_merge({ root: {width: 100 }}))
  styles do |theme|
    OtherComponent.styles
  end

  render do
    # during render styles can be accessed with `styles`, which is equivalent to the `classes` in the MaterialUI documentation.
    DIV(class: styles.root) { 'Some text' }
    # the theme from LucidMaterial::App can be accessed directly too:
    DIV(style: { width: theme.master.width }) { 'Some text' }
  end
end
```

The lifecycle callbacks starting with `unsafe_` are not supported.
Overwriting should_component_update is also not supported.

**Data flow of a LucidMaterial::Component within a LucidMaterial::App:**
![LucidComponent within a LucidApp Data Flow](https://raw.githubusercontent.com/isomorfeus/isomorfeus-react/master/images/data_flow_lucid_component.png)
