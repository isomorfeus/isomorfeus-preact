class TestAppApp < LucidApp::Base
  render do
    Router(hook: Preact.location_hook(props.location)) do
      Switch do
        Route(path: '/', component: HelloComponent.to_js)
        Route(path: '/ssr', component: HelloComponent.to_js)
        Route(path: '/welcome', component: WelcomeComponent.to_js)
        Route(component: Page404Component.to_js)
      end
    end
  end
end
