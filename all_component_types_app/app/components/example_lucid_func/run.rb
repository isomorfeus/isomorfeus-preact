module ExampleLucidFunc
  class Run < LucidFunc::Base
    render do
      (props.params.count.to_i / 10).times do |i|
        ExampleLucidFunc::AnotherFuncComponent(key: i)
      end
      nil
    end
  end
end
