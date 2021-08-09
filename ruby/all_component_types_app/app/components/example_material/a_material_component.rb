module ExampleMaterial
  class AMaterialComponent < LucidMaterial::Component::Base
    prop :text, default: 'prop not passed'

    styles do
      {
        master: {
          color: 'black'
        }
      }
    end

    state.some_bool = true

    class_store.b_bool = true

    def change_state(event)
      state.some_bool = !state.some_bool
    end

    def change_store(event)
      store.a_bool = !store.a_bool
    end

    def change_class_store(event)
      class_store.b_bool = !class_store.b_bool
    end

    def change_app_store(event)
      app_store.c_bool = !app_store.c_bool
    end

    render do
      SPAN(on_click: props.on_click, class: styles.root) { 'Click for orange alert! Props: ' }
      SPAN { props.text }
      SPAN(on_click: :change_state, class: styles.root) { ", state is: #{state.some_bool} (Click!)" }
      SPAN(on_click: :change_store, class: styles.root) { ", store is: #{store.a_bool} (Click!)" }
      SPAN(on_click: :change_class_store, class: styles.root) { ", class_store is: #{class_store.b_bool} (Click!)" }
      SPAN(on_click: :change_app_store, class: styles.root) { ", app_store is: #{app_store.c_bool} (Click!)" }
      SPAN { ', Children: '  }
      SPAN { props.children }
      SPAN { '| '}
    end
  end
end
