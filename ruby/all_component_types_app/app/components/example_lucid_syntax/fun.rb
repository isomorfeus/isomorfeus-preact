module ExampleLucidSyntax
  class Fun < LucidComponent::Base
    render do
      props.params.count.to_i.times do |i|
        AnotherLucidComponent(key: i)
      end
      nil
    end
  end
end
