class TestAppApp < LucidApp::Base
  render do
    Router(location: props.location) do
      Switch do
        Route(path: '/', exact: true, render: component_fun('HelloComponent'))
        Route(path: '/ssr', exact: true, render: component_fun('HelloComponent'))
        Route(path: '/welcome', exact: true, render: component_fun('WelcomeComponent'))
        Route(render: component_fun('Page404Component'))
      end
    end
  end
end
