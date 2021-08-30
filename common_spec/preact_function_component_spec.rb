require 'spec_helper'

RSpec.describe 'Preact::FunctionComponent' do
  it 'can render a component that is using inheritance' do
    doc = visit('/')
    doc.evaluate_ruby do
      class TestComponent < Preact::FunctionComponent::Base
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
        include Preact::FunctionComponent::Mixin
        render do
          DIV(id: :test_component) { 'TestComponent rendered' }
        end
      end
      Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
    end
    node = doc.wait_for('#test_component')
    expect(node.all_text).to include('TestComponent rendered')
  end

  context 'it accepts props and can' do
    before do
      @doc = visit('/')
    end

    it 'access them' do
      @doc.evaluate_ruby do
        class TestComponent < Preact::FunctionComponent::Base
          render do
            DIV(id: :test_component) do
              SPAN props.text
              SPAN props.other_text
            end
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { text: 'Prop passed!', other_text: 'Passed other prop!' }, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      all_text = node.all_text
      expect(all_text).to include('Prop passed!')
      expect(all_text).to include('Passed other prop!')
    end

    it 'accept a missing prop' do
      @doc.evaluate_ruby do
        class TestComponent < Preact::FunctionComponent::Base
          render do
            DIV(id: :test_component) { "nothing#{props.a_prop}here" }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { }, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('nothinghere')
    end
  end

  context 'it can handle events like' do
    before do
      @doc = visit('/')
    end

    it 'on_click' do
      @doc.evaluate_ruby do
        IT = { clicked: false }
        class TestComponent < Preact::FunctionComponent::Base
          def change_hash(event)
            IT[:clicked] = true
          end
          render do
            DIV(id: :test_component, on_click: :change_hash) { 'nothinghere' }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { }, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      node.click
      result = @doc.evaluate_ruby do
        IT[:clicked]
      end
      expect(result).to be true
    end
  end

  context 'it has hooks like' do
    before do
      @doc = visit('/')
    end

    it 'use_state' do
      @doc.evaluate_ruby do
        class TestComponent < Preact::FunctionComponent::Base
          render do
            value, set_value = use_state('nothinghere')
            handler = proc { |event| set_value.call('somethinghere') }
            DIV(id: :test_component, on_click: handler) { value }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { }, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      node.click
      expect(node.all_text).to include('somethinghere')
    end
  end
end
