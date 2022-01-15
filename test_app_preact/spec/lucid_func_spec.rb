require 'spec_helper'

RSpec.describe 'LucidFunc' do
  it 'can render a component that is using inheritance' do
    page = visit('/')
    page.eval_ruby do
      class TestComponent < LucidFunc::Base
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
        include LucidFunc::Mixin
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
        class TestComponent < LucidFunc::Base
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
        class TestComponent < LucidFunc::Base
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
        class TestComponent < LucidFunc::Base
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
        class TestComponent < LucidFunc::Base
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

  context 'it has a component store and can' do
    # LucidComponent MUST be used within a LucidApp for things to work

    before do
      @page = visit('/')
    end

    it 'use a uninitialized store value and can change it' do
      @page.eval_ruby do
        class TestComponent < LucidFunc::Base
          def change_state(event)
            store.something = true
          end
          render do
            if store.something
              DIV(id: :changed_component, on_click: :change_state) { "#{store.something}" }
            else
              DIV(id: :test_component, on_click: :change_state) { "nothing#{store.something}here" }
            end
          end
        end
        class OuterApp < LucidApp::Base
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('nothinghere')
      element.click
      element = @page.wait_for_selector('#changed_component')
      expect(element.inner_text).to include('true')
    end
  end

  context 'it has a component class_store and can' do
    # LucidComponent MUST be used within a LucidApp for things to work

    before do
      @page = visit('/')
    end

    it 'define a default class_store value and access it' do
      @page.eval_ruby do
        class TestComponent < LucidFunc::Base
          render do
            DIV(id: :test_component) { class_store.something }
          end
        end
        TestComponent.class_store.something = 'Something state intialized!'
        class OuterApp < LucidApp::Base
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('Something state intialized!')
    end

    it 'define a default class_store value and change it' do
      @page.eval_ruby do
        class TestComponent < LucidFunc::Base
          def change_state(event)
            class_store.something = false
          end
          render do
            if class_store.something
              DIV(id: :test_component, on_click: :change_state) { "#{class_store.something}" }
            else
              DIV(id: :changed_component, on_click: :change_state) { "#{class_store.something}" }
            end
          end
        end
        TestComponent.class_store.something = true
        class OuterApp < LucidApp::Base
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('true')
      element.click
      element = @page.wait_for_selector('#changed_component')
      expect(element.inner_text).to include('false')
    end

    it 'use a uninitialized store value and change it' do
      @page.eval_ruby do
        class TestComponent < LucidFunc::Base
          def change_state(event)
            class_store.something = true
          end
          render do
            if class_store.something
              DIV(id: :changed_component, on_click: :change_state) { "#{class_store.something}" }
            else
              DIV(id: :test_component, on_click: :change_state) { "nothing#{class_store.something}here" }
            end
          end
        end
        class OuterApp < LucidApp::Base
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('nothinghere')
      element.click
      element = @page.wait_for_selector('#changed_component')
      expect(element.inner_text).to include('true')
    end
  end

  context 'it has a app_store and can' do
    # LucidComponent MUST be used within a LucidApp for things to work

    before do
      @page = visit('/')
    end

    it 'define a default app_store value and access it' do
      @page.eval_ruby do
        AppStore.something = 'Something state intialized!'
      end
      @page.eval_ruby do
        class TestComponent < LucidFunc::Base
          render do
            DIV(id: :test_component) { app_store.something }
          end
        end
        class OuterApp < LucidApp::Base
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('Something state intialized!')
    end

    it 'define a default app_store value and change it' do
      @page.eval_ruby do
        AppStore.something = true
      end
      @page.eval_ruby do
        class TestComponent < LucidFunc::Base
          def change_state(event)
            app_store.something = false
          end
          render do
            if app_store.something
              DIV(id: :test_component, on_click: :change_state) { "#{app_store.something}" }
            else
              DIV(id: :changed_component, on_click: :change_state) { "#{app_store.something}" }
            end
          end
        end
        class OuterApp < LucidApp::Base
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('true')
      element.click
      element = @page.wait_for_selector('#changed_component')
      expect(element.inner_text).to include('false')
    end

    it 'use a uninitialized store value and change it' do
      @page.eval_ruby do
        class TestComponent < LucidFunc::Base
          def change_state(event)
            app_store.something = true
          end
          render do
            if app_store.something
              DIV(id: :changed_component, on_click: :change_state) { "#{app_store.something}" }
            else
              DIV(id: :test_component, on_click: :change_state) { "nothing#{app_store.something}here" }
            end
          end
        end
        class OuterApp < LucidApp::Base
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('nothinghere')
      element.click
      element = @page.wait_for_selector('#changed_component')
      expect(element.inner_text).to include('true')
    end
  end

  context 'it has styles and renders them' do
    before do
      @page = visit('/')
    end

    it 'with the styles block DSL' do
      @page.eval_ruby do
        class TestComponent < LucidFunc::Base
          styles do
            { master: { width: 100 }}
          end
          render do
            DIV(id: :test_component, class: styles.master) { "nothinghere" }
          end
        end
        class OuterApp < LucidApp::Base
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      # the following should be replaced by element.styles once its working correctly
      style = @page.eval <<~JAVASCRIPT
        window.getComputedStyle(document.querySelector('#test_component')).width
      JAVASCRIPT
      expect(style).to eq('100px')
    end

    it 'with the styles() DSL' do
      @page.eval_ruby do
        class TestComponent < LucidFunc::Base
          styles(master: { width: 100 })
          render do
            DIV(id: :test_component, class: styles.master) { "nothinghere" }
          end
        end
        class OuterApp < LucidApp::Base
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      # the following should be replaced by element.styles once its working correctly
      style = @page.eval <<~JAVASCRIPT
        window.getComputedStyle(document.querySelector('#test_component')).width
      JAVASCRIPT
      expect(style).to eq('100px')
    end

    it 'when they are shared' do
      @page.eval_ruby do
        class SuperComponent < LucidFunc::Base
          styles(master: { width: 100 })
          render do
            DIV(id: :super_component, class: styles.master) { "nothinghere" }
          end
        end
        # TODO for some reason, when use SuperComponent for inheritance, this fails on travis with 'Cyclic __proto__ value'
        # so use Base for the moment. Point is to check if the styles accessor is available from the class.
        class TestComponent < LucidFunc::Base
          styles do
            SuperComponent.styles
          end
          render do
            DIV(id: :test_component, class: styles.master) { "nothinghere" }
          end
        end
        class OuterApp < LucidApp::Base
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      # the following should be replaced by element.styles once its working correctly
      style = @page.eval <<~JAVASCRIPT
        window.getComputedStyle(document.querySelector('#test_component')).width
      JAVASCRIPT
      expect(style).to eq('100px')
    end
  end

  context 'it has a theme and styles and renders them' do
    before do
      @page = visit('/')
    end

    it 'with the styles block DSL' do
      @page.eval_ruby do
        class TestComponent < LucidFunc::Base
          styles do
            { master: { fontSize: 12 }}
          end
          render do
            DIV(id: :test_component, class: styles.master + theme.root) { "nothinghere" }
          end
        end
        class OuterApp < LucidApp::Base
          theme do
            { root: { width: 100 }}
          end
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      # the following should be replaced by element.styles once its working correctly
      style = @page.eval <<~JAVASCRIPT
        window.getComputedStyle(document.querySelector('#test_component')).width
      JAVASCRIPT
      expect(style).to eq('100px')
    end
  end
end
