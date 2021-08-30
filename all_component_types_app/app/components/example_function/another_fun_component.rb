module ExampleFunction
  class AnotherFunComponent < Preact::FunctionComponent::Base
    def show_red_alert(event)
      `alert("RED ALERT!")`
    end

    def show_orange_alert(event)
      `alert("ORANGE ALERT!")`
    end

    render do
      ExampleFunction::AFunComponent(on_click: :show_orange_alert, text: 'Yes') do
        SPAN(on_click: :show_red_alert) { 'Click for red alert! (Child 1), ' }
        SPAN { 'Child 2, '}
        SPAN { 'Child 3, '}
        SPAN { 'etc. '}
      end
    end
  end
end
