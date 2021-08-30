class AllTheFun < LucidComponent::Base
  render do
    DIV { ExampleFunction::AnotherFunComponent() }
    DIV { ExamplePreact::AnotherComponent() }
    DIV { ExampleLucid::AnotherLucidComponent() }
    DIV { ExampleLucidFunc::AnotherFuncComponent() }
    DIV { ExampleJS.AnotherComponent() }
  end
end
