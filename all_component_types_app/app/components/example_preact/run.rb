module ExamplePreact
  class Run < Preact::Component::Base
    render do
      (props.params.count.to_i / 10).times do |i|
        AnotherComponent(key: i)
      end
      nil
    end
  end
end
