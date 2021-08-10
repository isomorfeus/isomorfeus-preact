module ExampleLucidFunc
  class Fun < LucidFunc::Base
    render do
      props.params.count.to_i.times do |i|
        ExampleLucidFunc::AnotherFuncComponent(key: i)
      end
      nil
    end
  end
end
