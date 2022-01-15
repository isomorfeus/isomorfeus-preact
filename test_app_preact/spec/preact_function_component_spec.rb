require 'spec_helper'

RSpec.describe 'Preact::FunctionComponent' do
  it 'can render a component that is using inheritance' do
    page = visit('/')
    page.eval_ruby do
      class TestComponent < Preact::FunctionComponent::Base
        render do
          DIV(id: :test_component) { 'TestComponent rendered' }
        end
      end
      Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
      nil
    end
    element =page.wait_for_selector('#test_component')
    expect(element.inner_text).to include('TestComponent rendered')
  end

  it 'can render a component that is using the mixin' do
    page = visit('/')
    page.eval_ruby do
      class TestComponent
        include Preact::FunctionComponent::Mixin
        render do
          DIV(id: :test_component) { 'TestComponent rendered' }
        end
      end
      Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
      nil
    end
    element =page.wait_for_selector('#test_component')
    expect(element.inner_text).to include('TestComponent rendered')
  end

  context 'it accepts props and can' do
    before do
      @page = visit('/')
    end

    it 'access them' do
      @page.eval_ruby do
        class TestComponent < Preact::FunctionComponent::Base
          render do
            DIV(id: :test_component) do
              SPAN props.text
              SPAN props.other_text
            end
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { text: 'Prop passed!', other_text: 'Passed other prop!' }, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      all_text = element.inner_text
      expect(all_text).to include('Prop passed!')
      expect(all_text).to include('Passed other prop!')
    end

    it 'accept a missing prop' do
      @page.eval_ruby do
        class TestComponent < Preact::FunctionComponent::Base
          render do
            DIV(id: :test_component) { "nothing#{props.a_prop}here" }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { }, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('nothinghere')
    end
  end

  context 'it can handle events like' do
    before do
      @page = visit('/')
    end

    it 'on_click' do
      @page.eval_ruby do
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
        nil
      end
      element = @page.wait_for_selector('#test_component')
      element.click
      result = @page.eval_ruby do
        IT[:clicked]
      end
      expect(result).to be true
    end
  end

  context 'it has hooks like' do
    before do
      @page = visit('/')
    end

    it 'use_state' do
      @page.eval_ruby do
        class TestComponent < Preact::FunctionComponent::Base
          render do
            value, set_value = use_state('nothinghere')
            handler = proc { |event| set_value.call('somethinghere') }
            DIV(id: :test_component, on_click: handler) { value }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { }, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      element.click
      expect(element.inner_text).to include('somethinghere')
    end
  end
end
