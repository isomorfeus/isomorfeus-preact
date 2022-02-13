### LucidApp and LucidComponent

#### Store
This component is like a Preact::Component and in addition to it, allows do manage its state conveniently over redux using a simple DSL:
- `store` - works similar like the components state, but manages the components state with redux
- `class_store` - allows to have a class state, when changing this state, all instances of the components class render
- `app_store` - allows to access application state, when changing this state, all instances that have requested the same variables, will render.

The store data changes are passed using props instead of setting component state.
Therefore a LucidComponent needs a LucidApp as outer component.
LucidApp sets up a Preact::Context Provider, LucidComponent works as a Preact::Context Consumer.

```ruby

class MyComponent < LucidComponent::Base # is a Preact::Context Consumer

  render do
    # in a LucidComponent state can be used for local state managed by preact:
    state.some_var
    # in addition to that, store can be used for local state managed by redux:
    store.a_var
    # and for managing class state:
    class_store.another_var
    # and for managing application wide state:
    app_store.yet_another_var
    #
    DIV { 'Some text' }
  end
end
```

#### I18n
The LucidI18n::Mixin is automatically included into LucidComponent and LucidApp if available.

#### Theming and Styles
LucidApp also sets up theming. LucidApp and LucidComponents support styling:

```ruby
class MyApp < LucidApp::Base # is a Preact::Context Consumer
  # LucidApp can provide a styles theme
  theme do
    { master: { width: 200 }}
  end

  # styles can be set using a block that returns a hash
  styles do
    { root: {
        width: 200,
        height: 100
    }}
  end

  # or styles can be set using a hash:
  styles(root: { width: 100, height: 100 })

  # a component may refer to some other components styles
  styles do
    OtherComponent.styles
  end

  # styles and theme accessors return a css classname, they can be easily combined
  render do
    DIV(class: styles.root + theme.master) { 'Some text' }
  end
end
```

#### Lifecycle callbacks

The lifecycle callbacks starting with `unsafe_` are not supported.
Overwriting should_component_update is also not supported.

#### Preloading Data before render
Data or anything else that returns a promise can be preloaded before rendering from within LucidComponents
```ruby
class MyComponent < LucidComponent::Base
  # Use preload to define what needs to be loaded. The block result must be a promise.
  preload do
     MyGraph.promise_load.then { |g| @graph = g }
  end

  # The block passed to while_loading will be rendered until the promise is resolved
  while_loading do
    DIV "Loading data ... Please wait ..."
  end

  # the usual render block is shown when the data has been loaded
  render do
    @graph.all_nodes.each do |node|
      DIV node.name
    end
  end
end
```
#### Execution Environment
Sometimes its useful to prevent execution or rendering during Server Side Rendering or execute code specifically in a certain environment.
For this the environment helpers can be used:
- `on_browser?` - true if executing on the browser
- `on_ssr?` - true if executing in Server Side Rendering

```ruby
class MyComponent < LucidComponent::Base
  # use preload to define what needs to be loaded. The block result must be a promise.
  preload do
    if on_browser?
      MyGraph.promise_load.then { |g| @graph = g } # load the graph only on the browser
    else
      Promise.new
    end
  end

  # the block passed to while_loading wil be rendered until the data is loaded
  # and the promise is resolved
  while_loading do
    DIV "Loading data ... Please wait ..."
  end

  # the usual render block is shown when the data has been loaded
  render do
    if on_browser?
      CANVAS do
        # a canvas cannot be drawn to in Server Side Rendering, so paint the canvas only on the browser
      end
    end
    @graph.all_nodes.each do |node|
      DIV node.name
    end
  end
end
```
#### Data flow
**Data flow of a LucidComponent within a LucidApp:**
![LucidComponent within a LucidApp Data Flow](https://raw.githubusercontent.com/isomorfeus/isomorfeus-preact/master/images/data_flow_lucid_component.png)
