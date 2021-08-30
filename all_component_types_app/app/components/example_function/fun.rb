module ExampleFunction
  class Fun < Preact::FunctionComponent::Base
    render do
      props.params.count.to_i.times do |i|
        ExampleFunction::AnotherFunComponent(key: i)
      end
      nil
    end
  end
end
