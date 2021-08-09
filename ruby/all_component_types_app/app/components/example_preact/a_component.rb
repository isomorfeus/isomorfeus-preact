module ExamplePreact
  class AComponent < Preact::Component::Base
    prop :text, default: 'prop not passed'

    state.some_bool = true

    def change_state(event)
      state.some_bool = !state.some_bool
    end

    render do
      SPAN(on_click: props.on_click) { 'Click for orange alert! Props: ' }
      SPAN { props.text }
      SPAN(on_click: :change_state) { ", State is: #{state.some_bool} (Click!)" }
      SPAN { ', Children: '  }
      SPAN { props.children }
      SPAN { ' ' }
      SPAN { '| ' }
    end
  end
end
