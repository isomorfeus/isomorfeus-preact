module ExampleLucidSyntax
  class Jogging < LucidComponent::Base
    render do
      (props.match.count.to_i).times do |i|
        SimplyLucid(key: i, letter: 'a')
      end
      nil
    end
  end
end
