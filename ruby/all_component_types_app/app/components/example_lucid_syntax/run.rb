module ExampleLucidSyntax
  class Run < LucidComponent::Base
    render do
      (props.params.count.to_i / 12).times do |i|
        AnotherLucidComponent(key: i)
      end
      nil
    end
  end
end
