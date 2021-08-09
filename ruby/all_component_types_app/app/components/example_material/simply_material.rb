module ExampleMaterial
  class SimplyMaterial < LucidMaterial::Component::Base
    styles do
      {
        master: {
          color: 'black'
        }
      }
    end

    prop :letter, default: 'prop not passed'

    def change_letter(event)
      letter = app_store.letter
      code = `letter.charCodeAt(0)`
      code = code + 1
      code = 65 if code > 90
      app_store.letter = `String.fromCharCode(code)`
    end

    render do
      letter = app_store.letter
      if letter
        SPAN(on_click: :change_letter, class: styles.master) { letter + props.letter + ' ' }
      else
        app_store.letter = 'A'
      end
    end
  end
end
