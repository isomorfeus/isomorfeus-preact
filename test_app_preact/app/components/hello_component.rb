class PropTest
  extend LucidPropDeclaration::Mixin

  prop :email, validate.String.matches(/.+@.+/).max_length(64)
  prop :name, validate.String.matches(/T.+/).max_length(12)
end

class MemoTest < LucidFunc::Base
  render do
    DIV "Memo"
    DIV app_store.a_value
    DIV "b: #{app_store.b_value}"
  end
end

class HelloComponent < LucidComponent::Base
  styles do
    { test: { color: 'red' }}
  end

  ref :form

  def validate_form
    ruby_ref(:form).current.JS.validateForm()
  end

  def incr(event, info, arg)
    app_store.b_value = (app_store.b_value || 0) + 1
  end

  render do
    a = app_store.a_value
    c = class_store.a_value
    app_store.a_value = "a_value" unless a
    class_store.a_value = "c_value" unless c
    DIV 'Rendered!!'
    DIV "c: #{c}"
    DIV "a: #{a}"
    DIV(class: styles.test) { "a: #{a}" }
    DIV "Here was a Form"
    MemoTest()
    # keep, was a BUG: component resolution
    YetAnother::Switch()
    DIV(on_click: method_ref(:incr, 'hello')) { "incr b_value" }
    NavigationLinks()
  end
end
