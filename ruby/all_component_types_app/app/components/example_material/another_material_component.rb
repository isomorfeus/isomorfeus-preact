module ExampleMaterial
  class AnotherMaterialComponent < LucidMaterial::Component::Base
    styles do
      {
        master: {
          color: 'black'
        }
      }
    end

    def show_red_alert(event)
      `alert("RED ALERT!")`
    end

    def show_orange_alert(event)
      `alert("ORANGE ALERT!")`
    end

    render do
      AMaterialComponent(on_click: :show_orange_alert, text: 'Yes') do
        SPAN(on_click: :show_red_alert, class: styles.root) { 'Click for red alert! (Child 1), ' }
        SPAN { 'Child 2, '}
        SPAN { 'etc. '}
      end
    end
  end
end
