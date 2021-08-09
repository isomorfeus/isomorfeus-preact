module ExamplePreact
  class Run < Preact::Component::Base
    render do
      (props.match.count.to_i / 10).times do |i|
        AnotherComponent(key: i)
      end
      nil
    end
  end
end
