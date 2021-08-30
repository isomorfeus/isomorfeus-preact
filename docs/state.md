### State
State can be accessed in components using `state`:
```ruby
class MyComponent < Preact::Component::Base
  render do
    if state.toggled
      DIV { 'toggled' }
    else
      DIV { 'not toggled' }
    end
  end
end
```
State can be intialized like so:
```ruby
class MyComponent < Preact::Component::Base
  state.toggled = false
  
  render do
    if state.toggled
      DIV { 'toggled' }
    else
      DIV { 'not toggled' }
    end
  end
end
```
State can be changed like so, the component setState() will be called:
```ruby
class MyComponent < Preact::Component::Base
  render do
    if some_condition_is_met
      
      state.toggled = true # calls components setState to cause a render
      
      # or if a callback is needed:
      
      set_state({toggled: true}) do
        # some callback code here
      end
    end
    if state.toggled
      DIV { 'toggled' }
    else
      DIV { 'not toggled' }
    end
  end
end
```
When changing state, the state is not immediately available, just like in Preact! For example:
```ruby
class MyComponent < Preact::Component::Base
  render do
    previous_state_value = state.variable
    state.variable = next_state_value # even though this looks like a assignment, it causes a side effect
                                      # state may be updated after the next render cycle
    next_state_value == state.variable # very probably false here until next render
    previous_state_value == state.variable # probably true here until next render
    
    # to work with next_state_value, wait for the next render cycle, or just keep using the next_state_value variable here instead of state.value
  end
end
```
To make the side effect of a set_state more visible, state can be set by using a method call instead of a assignment:
```ruby
class MyComponent < Preact::Component::Base
  render do
    previous_state_value = state.variable
    state.variable(next_state_value) # setting state with a method call, it causes a side effect
                                     # state may be updated after the next render cycle
    next_state_value == state.variable # very probably false here until next render
    previous_state_value == state.variable # probably true here until next render
    
    # to work with next_state_value, wait for the next render cycle, or just keep using the next_state_value variable here instead of state.value
  end
end
```
