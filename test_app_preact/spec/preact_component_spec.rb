require 'spec_helper'

RSpec.describe 'Preact::Component' do
  # tests are running in production mode, so we dont see all warning messages of preact like in development

  context 'it can render a component that is using' do
    before do
      @page = visit('/')
    end

    it 'inheritance' do
      @page.eval_ruby do
        class TestComponent < Preact::Component::Base
          render do
            DIV(id: :test_component) { 'TestComponent rendered' }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('TestComponent rendered')
    end

    it 'mixin' do
      @page.eval_ruby do
        class TestComponent
          include Preact::Component::Mixin
          render do
            DIV(id: :test_component) { 'TestComponent rendered' }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('TestComponent rendered')
    end
  end

  context 'it has state and can' do
    before do
      @page = visit('/')
    end

    it 'define a default state value and access it' do
      @page.eval_ruby do
        class TestComponent < Preact::Component::Base
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
        class TestComponent < Preact::Component::Base
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
        class TestComponent < Preact::Component::Base
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

    it 'can compare state' do
      result = @page.eval_ruby do
        s1 = Preact::State.new(`{state: {test: 1}}`)
        s2 = Preact::State.new(`{state: {test: 1}}`)
        s3 = Preact::State.new(`{state: {test: 2}}`)
        [s1 == s1, s1 == s3]
      end
      expect(result).to eq([true, false])
    end

    it 'can ask for key?' do
      result = @page.eval_ruby do
        p1 = Preact::State.new(`{state: {test: 1}}`)
        p2 = Preact::State.new(`{state: {toast: 1}}`)
        [p1.key?(:test), p2.key?(:test)]
      end
      expect(result).to eq([true, false])
    end

    it 'can access prop by []' do
      result = @page.eval_ruby do
        p1 = Preact::State.new(`{state: {test: true}}`)
        p2 = Preact::State.new(`{state: {toast: true}}`)
        [p1[:test], p2[:test].nil?]
      end
      expect(result).to eq([true, true])
    end
  end

  context 'it accepts props and can' do
    before do
      @page = visit('/')
    end

    it 'access them' do
      @page.eval_ruby do
        class TestComponent < Preact::Component::Base
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
        class TestComponent < Preact::Component::Base
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
        class TestComponent < Preact::Component::Base
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
        class TestComponent < Preact::Component::Base
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
        class TestComponent < Preact::Component::Base
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
        class TestComponent < Preact::Component::Base
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
        class TestComponent < Preact::Component::Base
          prop :a_prop, class: String, required: false
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

    it 'use a default value for a missing, optional prop' do
      @page.eval_ruby do
        class TestComponent < Preact::Component::Base
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

    it 'use a default value for a missing, optional prop, new style' do
      @page.eval_ruby do
        class TestComponent < Preact::Component::Base
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

    it 'convert props to hash' do
      @page.eval_ruby do
        class TestComponent < Preact::Component::Base
          prop :a_prop, class: String, required: false
          render do
            DIV(id: :test_component) { props.to_h[:a_prop] }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { a_prop: 'heyho' }, '#test_anchor')
        nil
      end
      element = @page.wait_for_selector('#test_component')
      expect(element.inner_text).to include('heyho')
    end
  end

  context 'it can use callbacks like' do
    before do
      @page = visit('/')
    end

    it 'component_did_catch' do
      @page.eval_ruby do
        class ComponentWithError < Preact::Component::Base
          def text
            'Error caught!'
          end
          render do
            DIV(id: :error_component) { send(props.text_method) }
          end
        end
        class TestComponent < Preact::Component::Base
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
        class TestComponent < Preact::Component::Base
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
        class TestComponent < Preact::Component::Base
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
        class TestComponent < Preact::Component::Base
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

    it 'on_click by symbol' do
      @page.eval_ruby do
        class TestComponent < Preact::Component::Base
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

    it 'on_click by method_ref' do
      @page.eval_ruby do
        class TestComponent < Preact::Component::Base
          def change_state(event)
            state.something = true
          end
          render do
            if state.something
              DIV(id: :changed_component, on_click: method_ref(:change_state)) { "#{state.something}" }
            else
              DIV(id: :test_component, on_click: method_ref(:change_state)) { "nothing#{state.something}here" }
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

    it 'on_click by method_ref and can pass additional args' do
      @page.eval_ruby do
        class TestComponent < Preact::Component::Base
          def change_state(event, info, arg)
            state.something = arg
          end
          render do
            if state.something
              DIV(id: :changed_component, on_click: method_ref(:change_state)) { "#{state.something}" }
            else
              DIV(id: :test_component, on_click: method_ref(:change_state, true)) { "nothing#{state.something}here" }
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

  context 'it supports refs' do
    before do
      @page = visit('/')
    end

    it 'when they are blocks' do
      result = @page.eval_ruby do
        IT = { ref_received: false }
        class TestComponent < Preact::Component::Base
          ref :div_ref do |element|
            IT[:ref_received] = true if element[:id] == 'test_component'
          end
          render do
            DIV(id: :test_component, ref: ref(:div_ref)) { 'a div with a ref' }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
        IT[:ref_received]
      end
      @page.wait_for_selector('#test_component')
      expect(result).to be true
    end

    it 'when they are simple refs' do
      @page.eval_ruby do
        IT = { ref_received: false }
        class TestComponent < Preact::Component::Base
          def report_ref(event)
            IT[:ref_received] = true if ruby_ref(:div_ref).current[:id] == 'test_component'
          end
          ref :div_ref
          render do
            DIV(id: :test_component, ref: ref(:div_ref), on_click: :report_ref) { 'a div with a ref' }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
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

  context 'it supports history' do
    before do
      @page = visit('/')
    end

    it 'and can go back' do
      @page.wait_for_navigation { @page.click_el('#link_welcome') }
      expect(@page).to have_content('Go back')
      @page.wait_for_navigation { @page.click_el('#button_back') }
      expect(@page).to have_content('Rendered!!')
    end
  end
end
