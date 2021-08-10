module ExampleFunction
  class Run < Preact::FunctionComponent::Base
    render do
      (props.params.count.to_i / 10).times do |i|
        ExampleFunction::AnotherFunComponent(key: i)
      end
      nil
    end
  end
end
