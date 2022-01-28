### Props

In ruby props are underscored: `className -> class_name`. The conversion for Preact is done automatically.
Within a component props can be accessed using `props`:
```ruby
class MyComponent < Preact::Component::Base
  render do
    DIV { props.text }
  end
end
```
Props are passed as arguments to the component:
```ruby
class MyOtherComponent < Preact::Component::Base
  render do
    MyComponent(text: 'some other text')
  end
end
```

### Prop Declaration
#### Using options hash style
Props can be declared and type checked and a default value can be given:
```ruby
class MyComponent < Preact::Component::Base
  prop :text, class: String # a required prop of class String, class must match exactly
  prop :maybe_text, class: String, allow_nil: true # a required prop of class String, class must match exactly but a nil value is also ok.
  prop :other, is_a: Enumerable # a required prop, which can be a Array for example, but at least must be a Enumerable
  prop :cool, default: 'yet some more text' # a optional prop with a default value
  prop :even_cooler, class: String, required: false # a optional prop, which when given, must be of class String
  prop :is_it, type: :boolean # ruby has no Boolean class, for validating a boolean the type: :boolean must be used.
  prop :super # a required prop of any type
  prop :email_address, type: :email # special email type, email must be a string
  prop :website, type: :uri # special uri type, must contain uri scheme. uri must be a string

  render do
    DIV { props.text }
  end
end
```
#### Useful methods
```ruby
class MyComponent < Preact::Component::Base
  render do
    if props.key?(:text) # the key? method can be used, to check if a certain property is included in props
      DIV { props.text }
    else
      UL do
        %i[one two three].each do |prop|
          LI { props[prop] } # the [] accessor can be used, if a prop is dynamically determined
        end
      end
    end
  end
end
```
#### Using validate method style
Props can be declared and type checked and a default value can be given using a validate method chain::
```ruby
class MyComponent < Preact::Component::Base
  prop :text, validate.String # a required prop of class String, class must match exactly
  prop :other, validate.Enumerable # a required prop, which can be a Array for example, but at least must be a Enumerable
  prop :cool, validate.default('yet some more text') # a optional prop with a default value
  prop :even_cooler, validate.String.optional # a optional prop, which when given, must be of class String
  prop :super # a required prop of any type

  render do
    DIV { props.text }
  end
end
```
More complex variations are possible and can be expressed in a concise way:
```ruby
class MyComponent < Preact::Component::Base
  prop :float, validate.Float.cast.default(1.0).min(0.5).and.max(1.5)
  prop :text, validate.String.matches(/(a|b|c).*/).length(5)

  render do
    DIV { props.float.to_s }
  end
end
```

A validate method chain must start with the `validate` method.

#### Supported types methods for the validate method style
Checked for exact class:
- Array
- Float
- Hash
- Integer
- String
- Boolean (checked for TrueClass or FalseClass)
- Email (must be a String, validated via regexp)
- Uri (must be a String, validated via method call)

Checked for superclass or module containing:
- Enumerable

Examples:
```ruby
prop :beer, validate.Float
prop :carpet, validate.Float
```

#### Other types for validate method style
Any other type can be supported with the following methods:
- `is_a(class)` checks for superclass or module containing class: `prop :some, validate.is_a(Rabbit)`
- `exact_class(class)`, checks for exact class: `prop :car, validate.exact_class(MercedesBenzSClass)`

Examples:
```ruby
prop :beer, validate.is_a(Liquid)
prop :carpet, validate.exact_class(Carpet)
```

#### validate method chain methods
- `cast` Tries to cast the value to any of the supported types above before validation: `prop :a_guy, validate.Integer.cast`
- `default(value)` Provide a default value, makes prop optional: `prop :food, validate.default('vegetarian')`
- `ensure(value)` If the given value is nil, change it to value: `prop :text, validate.String.ensure('')`
- `greater_than(value)`, `gt(value)` Checks value of numeric types: `prop :val, validate.Integer.greater_than(1)`
- `keys(*keys)` checks if a Hash contains the given keys: `prop :display, validate.Hash.keys(:size, :color)`
- `length(l)`, `size(l)` checks length of String, Enumarable, Array and Hash: `prop :list, validate.Enumarable.length(5)`
- `less_than(value)`, `lt(value)` Checks value of numeric types: `prop :val, validate.Integer.less_than(1)`
- `matches(reg_exp)`, matches a String against a regular expression: `prop :rope, validate.String.matches(/(a|b).*/)`
- `max(v)` checks numeric types: `prop :array, validate.Integer.max(5)`
- `max_size(l)`, `max_length(l)` checks max length of enumerable types or string: `prop :array, validate.Array.max_size(5)`
- `min(v)` checks numeric types: `prop :array, validate.Integer.min(5)`
- `min_size(l)`, `min_length(l)` checks min length of enumerable types or string: `prop :array, validate.Array.min_size(5)`
- `negative`, checks if numeric value is negative: `prop :numer, validate.Integer.negative`
- `optional`, declares prop as optional: `prop :numer, validate.Integer.optional`
- `positive`, checks if numeric value is positive: `prop :numer, validate.Integer.positive`
- `required`, declares prop as required: `prop :numer, validate.Integer.required`

- sugar methods
    - `and`
    - `is`
    - `has`
    - `with`

These methods are helper methods to express more clearly in language.
Example: `prop :wine, validate.String.with.length(5).and.matches(/(a|b}.*/)`

#### Ensuring a custom value or range
A ensure proc can be passed. That proc gets a value and is expected to return a value or raise if desired.
If a ensure proc is given, setting a default value, the cast and type checks are skipped.
Example:
```ruby
class MyComponent < Preact::Component::Base
  prop :float_a, ensure: proc { |v| v = 1 if v < 1; v }
  prop :float_b, validate.ensure { |v| v = 2 if v > 2; v }

  render do
    DIV { props.float_a.to_s }
    DIV { props.float_b.to_s }
  end
end
```

#### Custom validation block
A validate_block can be passed. That block gets a value and is expected to return a value or raise if desired.
Setting a default value, a ensure block, cast and type checks are executed before the validate_block
Example:
```ruby
class MyComponent < Preact::Component::Base
  prop :float_a, validate_block: proc { |v| raise 'error' unless v.is_a?(Float) }
  prop :float_b, validate.validate_block { |v| raise 'error' unless v.is_a?(Float) }

  render do
    DIV { props.float_a.to_s }
    DIV { props.float_b.to_s }
  end
end
```

#### Validating props

Props can be validated by calling:
```ruby
MyClass.valid_props?(props_hash) # returns a boolean
MyClass.validate_props(props_hash) # returns true or will raise
MyClass.validated_props(props_hash) # returns a hash of validated and ensured props values or will raise
```
or individually, a single prop:
```ruby
MyClass.valid_prop?(prop_name, prop_value) # returns a boolean
MyClass.validate_prop(prop_name, prop_value) # returns true or will raise
MyClass.validated_prop(prop_name, prop_value) # returns the validated and ensured value of prop or will raise
```

### Passing methods in props of Components
To prevent constant rerenders when using procs during render it is recommended to define methods instead and pass them by reference.
Isomorfeus Preact provides the helper `method_ref(:method_name)` for doing so. Example:

```ruby
class MyComponent < LucidComponent::Base

  def my_method
    # do something
  end

  render do
    AnotherComponent(callback: method_ref(:my_method)) # provide access to local my_method and preventing rerender of AnotherComponent

    AnotherComponent(callback: proc { my_method }) # this works too, but will rerender AnotherComponent each time,
                                                   # as the proc is recreated for each render causing passed props to change
  end

end
```

### Props Outside Components

The props as above are used within the isomorfeus framework for isomorfeus-data classes and isomorfeus-operation.
These props can be used in any class simple by extending the class, example:
```ruby
class MyClass
  extend LucidPropDeclaration::Mixin
end
```
This makes all of the above available.

### Props in Forms
Especially when using LucidNodes from isomorfeus-data, but also for any other class with props, its helpful to have the form
validate the input. The LucidPropsDeclaration::Mixin provides helper functions, that can be used with various preact
form components to automatically do the validation. For validating all declared props, for example for a complete form:
```ruby
MyClass.validate_function
```
It returns a javascript function that can be called by the form component. `function(props_object)`


To validate a single prop for a specific form input:
```ruby
MyClass.validate_prop_function(prop_name)
```
It returns a javascript function, that can called by a form input component. `function(value)`

Example:
```ruby
class PropTest # just to show props, could be any LucidNode or LucidOperation or anything else that accepts props
  extend LucidPropDeclaration::Mixin

  prop :email, validate.String.matches(/.+@.+/).max_length(64)
  prop :name, validate.String.matches(/T.+/).max_length(12)
end

class HelloComponent < LucidMaterial::Component::Base
  render do
    Formik.Formik(initial_values: { email: 'test@test', name: 'Test Test' }.to_n) do
      Formik.Form do
        # here the PropTest.validate_prop_function(:email) returns a function that is used by formik for field level validation
        Formik.Field(type: :email, name: :email, validate: PropTest.validate_prop_function(:email))
        Formik.ErrorMessage(name: :email, component: :div)
        # here the PropTest.validate_prop_function(:name) returns a function that is used by formik for field level validation
        Formik.Field(type: :text, name: :name, validate: PropTest.validate_prop_function(:name))
        Formik.ErrorMessage(name: :name, component: :div)
        BUTTON(type: "submit") { 'Submit' }
      end
    end
  end
end
```


