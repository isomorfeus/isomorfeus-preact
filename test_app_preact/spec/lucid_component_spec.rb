require 'spec_helper'

RSpec.describe 'LucidComponent' do
  it 'can render a component that is using inheritance' do
    page = visit('/')
    page.eval_ruby do
      class TestComponent < LucidComponent::Base
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
        include LucidComponent::Mixin
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

  context 'it has state and can' do
    before do
      @page = visit('/')
    end

    it 'define a default state value and access it' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
          state.something = 'Something state intialized!'
          render do
            DIV(id: :test_component) { state.something }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('Something state intialized!')
    end

    it 'define a default state value and change it' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
          def change_state(event)
            state.something = false
          end
          state.something = true
          render do
            if state.something
              DIV(id: :test_component, on_click: :change_state) { "#{state.something}" }
            else
              DIV(id: :changed_component, on_click: :change_state) { "#{state.something}" }
            end
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('true')
      element.click
      element = @page.wait_for_selector('#changed_component')
      expect(element.inner_text).to include('false')
    end

    it 'use a uninitialized state value and change it' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
          def change_state(event)
            state.something = true
          end
          render do
            if state.something
              DIV(id: :changed_component, on_click: :change_state) { "#{state.something}" }
            else
              DIV(id: :test_component, on_click: :change_state) { "nothing#{state.something}here" }
            end
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('nothinghere')
      element.click
      element = @page.wait_for_selector('#changed_component')
      expect(element.inner_text).to include('true')
    end
  end

  context 'it accepts props and can' do
    before do
      @page = visit('/')
    end

    it 'access them' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
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

    it 'access a required prop of any type' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
          prop :any
          render do
            DIV(id: :test_component) do
              SPAN props.any
              SPAN props.other_text
            end
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { any: 'Prop passed!', other_text: 'Passed other prop!' }, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      all_text = element.inner_text
      expect(all_text).to include('Prop passed!')
      expect(all_text).to include('Passed other prop!')
    end

    it 'access a required, exact type' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
          prop :a_prop, class: String
          render do
            DIV(id: :test_component) { props.a_prop.class.to_s }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { a_prop: 'Prop passed!' }, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('String')
    end

    it 'access a required, more generic type' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
          prop :a_prop, is_a: Enumerable
          render do
            DIV(id: :test_component) { props.a_prop.class.to_s }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { a_prop: [1, 2, 3] }, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('Array')
    end

    it 'accept a missing prop' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
          prop :a_prop, class: String
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

    it 'accept a unwanted type in production' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
          prop :a_prop, class: String
          render do
            DIV(id: :test_component) { "nothing#{props.a_prop}here" }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { a_prop: 10 }, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('nothing10here')
    end

    it 'accept a missing, optional prop' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
          prop :a_prop, class: String, required: false
          render do
            DIV(id: :test_component) { "nothing#{props.a_prop}here" }
          end
        end
        begin
          Isomorfeus::TopLevel.mount_component(TestComponent, { }, '#test_anchor')
          nil
        rescue Exception => e
          e
        end
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('nothinghere')
    end

    it 'uses a default value for a missing, optional prop' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
          prop :a_prop, class: String, default: 'Prop not passed!'
          render do
            DIV(id: :test_component) { props.a_prop }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { }, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('Prop not passed!')
    end

    it 'uses a default value for a missing, optional prop, new style' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
          prop :a_prop, validate.String.default('Prop not passed!')
          render do
            DIV(id: :test_component) { props.a_prop }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { }, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('Prop not passed!')
    end
  end

  context 'it can use callbacks like' do
    before do
      @page = visit('/')
    end

    it 'component_did_catch' do
      @page.eval_ruby do
        class ComponentWithError < LucidComponent::Base
          def text
            'Error caught!'
          end
          render do
            DIV(id: :error_component) { send(props.text_method) }
          end
        end
        class TestComponent < LucidComponent::Base

          render do
            DIV(id: :test_component) { ComponentWithError(text_method: state.text_method) }
          end
          component_did_catch do |error, info|
            state.text_method = :text
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('Error caught!')
    end

    it 'component_did_mount' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
          render do
            DIV(id: :test_component) { state.some_text }
          end
          component_did_mount do
            state.some_text = 'some other text'
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('some other text')
    end

    it 'component_did_update' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
          render do
            DIV(id: :test_component) { state.some_text }
          end
          component_did_mount do
            state.some_text = 'some other text'
          end
          component_did_update do |prev_props, prev_state, snapshot|
            if prev_state.some_text != '100'
              state.some_text = '100'
            end
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('100')
    end

    it 'component_will_unmount' do
      result = @page.eval_ruby do
        IT = { unmount_received: false }
        class TestComponent < LucidComponent::Base
          render do
            DIV(id: :test_component) { state.some_text }
          end
          component_will_unmount do
            IT[:unmount_received] = true
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
        Preact.unmount_component_at_node('#test_anchor')
        IT[:unmount_received]
      end
      expect(result).to be true
    end
  end

  context 'it can handle events like' do
    before do
      @page = visit('/')
    end

    it 'on_click' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
          def change_state(event)
            state.something = true
          end
          render do
            if state.something
              DIV(id: :changed_component, on_click: :change_state) { "#{state.something}" }
            else
              DIV(id: :test_component, on_click: :change_state) { "nothing#{state.something}here" }
            end
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('nothinghere')
      element.click
      element = @page.wait_for_selector('#changed_component')
      expect(element.inner_text).to include('true')
    end
  end

  context 'it has a component store and can' do
    # LucidComponent MUST be used within a LucidApp for things to work

    before do
      @page = visit('/')
    end

    it 'use a uninitialized state value and change it' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
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
        class TestComponent < LucidComponent::Base
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
        class TestComponent < LucidComponent::Base
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

    it 'use a uninitialized state value and change it' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
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
        class TestComponent < LucidComponent::Base
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
        class TestComponent < LucidComponent::Base
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

    it 'use a uninitialized state value and change it' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
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

  context 'it has session store and can' do
    before do
      @page = visit('/')
    end

    it 'set and get values' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
          def change_state(event)
            session_store.something = true
            force_update
          end
          render do
            if session_store.something
              DIV(id: :changed_component, on_click: :change_state) { "#{session_store.something}" }
            else
              DIV(id: :test_component, on_click: :change_state) { "nothing#{session_store.something}here" }
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

  context 'it has local store and can' do
    before do
      @page = visit('/')
    end

    it 'set and get values' do
      @page.eval_ruby do
        class TestComponent < LucidComponent::Base
          def change_state(event)
            local_store.something = true
            force_update
          end
          render do
            if local_store.something
              DIV(id: :changed_component, on_click: :change_state) { "#{local_store.something}" }
            else
              DIV(id: :test_component, on_click: :change_state) { "nothing#{local_store.something}here" }
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
        class TestComponent < LucidComponent::Base
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
        class TestComponent < LucidComponent::Base
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
        class SuperComponent < LucidComponent::Base
          styles(master: { width: 100 })
          render do
            DIV(id: :super_component, class: styles.master) { "nothinghere" }
          end
        end
        # TODO for some reason, when use SuperComponent for inheritance, this fails on travis with 'Cyclic __proto__ value'
        # so use Base for the moment. Point is to check if the styles accessor is available from the class.
        class TestComponent < LucidComponent::Base
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
        class TestComponent < LucidComponent::Base
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

  context 'it supports refs' do
    before do
      @page = visit('/')
    end

    it 'when they are blocks' do
      result = @page.eval_ruby do
        IT = { ref_received: false }
        class TestComponent < LucidComponent::Base
          ref :div_ref do |element|
            IT[:ref_received] = true if element[:id] == 'test_component'
          end
          render do
            DIV(id: :test_component, ref: ref(:div_ref)) { 'a div with a ref' }
          end
        end
        class OuterApp < LucidApp::Base
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
        IT[:ref_received]
      end
      @page.wait_for_selector('#test_component')
      expect(result).to be true
    end

    it 'when they are simple refs' do
      @page.eval_ruby do
        IT = { ref_received: false }
        class TestComponent < LucidComponent::Base
          def report_ref(event)
            IT[:ref_received] = true if ruby_ref(:div_ref).current[:id] == 'test_component'
          end
          ref :div_ref
          render do
            DIV(id: :test_component, ref: ref(:div_ref), on_click: :report_ref) { 'a div with a ref' }
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
      @page.wait_for_selector('#test_component')
      @page.find('#test_component').click
      result = @page.eval_ruby do
        IT[:ref_received]
      end
      expect(result).to be true
    end
  end
end
