class TestAppApp < LucidApp::Base
  render do
    Router(hook: Preact.location_hook(props.location)) do
      Switch do
        Route(path: '/', component: component_fun('HelloComponent'))
        Route(path: '/ssr', component: component_fun('HelloComponent'))
        Route(path: '/welcome', component: component_fun('WelcomeComponent'))
        Route(component: component_fun('Page404Component'))
      end
    end
  end
end
