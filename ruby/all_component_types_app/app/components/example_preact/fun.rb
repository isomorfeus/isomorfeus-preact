module ExamplePreact
  class Fun < Preact::Component::Base
    render do
      props.match.count.to_i.times do |i|
        AnotherComponent(key: i)
      end
      nil
    end
  end
end
