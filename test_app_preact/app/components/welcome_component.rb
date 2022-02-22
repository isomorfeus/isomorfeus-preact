class WelcomeComponent < Preact::FunctionComponent::Base
  def go_back
    history.back
  end

  render do
    DIV "Welcome!"
    BUTTON(id: :button_back, on_click: :go_back) { "Go back" }
    NavigationLinks()
  end
end
