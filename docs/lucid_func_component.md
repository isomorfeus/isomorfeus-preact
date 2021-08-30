### LucidFunc and LucidMaterial::Func

#### Hooks
With these classes and mixins its possible to create function components which support almost all features of Lucid and LucidMaterial Class
Components. LucidFunc and LucidMaterial::Func are especially suited for use with Preact Hooks which can be used in the render block.
```ruby
class MyFunctionComponent < LucidMaterial::Func::Base
  render do
    theme = SomeImportedLibrary.useSomeSuperHook
    # or more ruby style
    theme = SomeImportedLibrary.use_some_super_hook
```

#### Restrictions
Automatic prop validation is not applied to these component types. Props can be manually validated if desired.
