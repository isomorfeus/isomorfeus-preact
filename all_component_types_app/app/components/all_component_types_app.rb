class AllComponentTypesApp < LucidApp::Base
  render do
    Router(hook: Preact.location_hook(props.location)) do
      Switch do
        Route(path: '/fun_fun/:count', component: ExampleFunction::Fun.JS[:preact_component])
        Route(path: '/fun_run/:count', component: ExampleFunction::Run.JS[:preact_component])
        Route(path: '/com_fun/:count', component: ExamplePreact::Fun.JS[:preact_component])
        Route(path: '/com_run/:count', component: ExamplePreact::Run.JS[:preact_component])
        Route(path: '/luc_fun/:count', component: ExampleLucid::Fun.JS[:preact_component])
        Route(path: '/luc_run/:count', component: ExampleLucid::Run.JS[:preact_component])
        Route(path: '/func_fun/:count', component: ExampleLucidFunc::Fun.JS[:preact_component])
        Route(path: '/func_run/:count', component: ExampleLucidFunc::Run.JS[:preact_component])
        Route(path: '/lucs_fun/:count', component: ExampleLucid::Jogging.JS[:preact_component])
        Route(path: '/lucs_run/:count', component: ExampleLucid::Jogging.JS[:preact_component])
        Route(path: '/lucsy_fun/:count', component: ExampleLucidSyntax::Fun.JS[:preact_component])
        Route(path: '/lucsy_run/:count', component: ExampleLucidSyntax::Run.JS[:preact_component])
        Route(path: '/lucssy_fun/:count', component: ExampleLucidSyntax::Jogging.JS[:preact_component])
        Route(path: '/lucssy_run/:count', component: ExampleLucidSyntax::Jogging.JS[:preact_component])
        Route(path: '/js_fun/:count', component: `global.ExampleJS.Fun`)
        Route(path: '/js_run/:count', component: `global.ExampleJS.Run`)
        Route(path: '/all_the_fun/:count', component: AllTheFun.JS[:preact_component])
        Route(path: '/', component: ShowLinks.JS[:preact_component])
        Route(component: NotFound404Component.JS[:preact_component])
      end
    end
  end
end
