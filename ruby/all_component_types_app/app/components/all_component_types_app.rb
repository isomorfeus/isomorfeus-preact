class AllComponentTypesApp < LucidMaterial::App::Base
  render do
    Router(location: props.location) do
      Switch do
        Route(path: '/fun_fun/:count', exact: true, component: ExampleFunction::Fun.JS[:preact_component])
        Route(path: '/fun_run/:count', exact: true, component: ExampleFunction::Run.JS[:preact_component])
        Route(path: '/com_fun/:count', exact: true, component: ExamplePreact::Fun.JS[:preact_component])
        Route(path: '/com_run/:count', exact: true, component: ExamplePreact::Run.JS[:preact_component])
        Route(path: '/luc_fun/:count', exact: true, component: ExampleLucid::Fun.JS[:preact_component])
        Route(path: '/luc_run/:count', exact: true, component: ExampleLucid::Run.JS[:preact_component])
        Route(path: '/func_fun/:count', exact: true, component: ExampleLucidFunc::Fun.JS[:preact_component])
        Route(path: '/func_run/:count', exact: true, component: ExampleLucidFunc::Run.JS[:preact_component])
        Route(path: '/lucs_fun/:count', exact: true, component: ExampleLucid::Jogging.JS[:preact_component])
        Route(path: '/lucs_run/:count', exact: true, component: ExampleLucid::Jogging.JS[:preact_component])
        Route(path: '/lucsy_fun/:count', exact: true, component: ExampleLucidSyntax::Fun.JS[:preact_component])
        Route(path: '/lucsy_run/:count', exact: true, component: ExampleLucidSyntax::Run.JS[:preact_component])
        Route(path: '/lucssy_fun/:count', exact: true, component: ExampleLucidSyntax::Jogging.JS[:preact_component])
        Route(path: '/lucssy_run/:count', exact: true, component: ExampleLucidSyntax::Jogging.JS[:preact_component])
        Route(path: '/js_fun/:count', exact: true, component: `global.ExampleJS.Fun`)
        Route(path: '/js_run/:count', exact: true, component: `global.ExampleJS.Run`)
        Route(path: '/all_the_fun/:count', exact: true, component: AllTheFun.JS[:preact_component])
        Route(path: '/', strict: true, component: ShowLinks.JS[:preact_component])
        Route(component: NotFound404Component.JS[:preact_component])
      end
    end
  end
end
