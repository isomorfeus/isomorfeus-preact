require 'spec_helper'

RSpec.describe 'React::PureComponent' do
  it 'can render a component that is using inheritance' do
    doc = visit('/')
    doc.evaluate_ruby do
      class TestComponent < React::PureComponent::Base
        render do
          DIV(id: :test_component) { 'TestComponent rendered' }
        end
      end
      Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
    end
    node = doc.wait_for('#test_component')
    expect(node.all_text).to include('TestComponent rendered')
  end

  it 'can render a component that is using the mixin' do
    doc = visit('/')
    doc.evaluate_ruby do
      class TestComponent
        include React::PureComponent::Mixin
        render do
          DIV(id: :test_component) { 'TestComponent rendered' }
        end
      end
      Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
    end
    node = doc.wait_for('#test_component')
    expect(node.all_text).to include('TestComponent rendered')
  end
end