require 'spec_helper'

RSpec.describe 'Component Resolution' do
  before do
    @doc = visit('/')
    # create several kinds components, nested
    # resolution for Preact::Component, LucidComponent is the same
    # but we need to check in addition to one of the above Preact::FunctionComponent, which has the same resolution as the Preact::MemoComponent
    # and we need to check Native Components (see test_app, isomorfeus_loader.rb)
    # and we need to check resolution from element blocks
    @doc.evaluate_ruby do
      class TopPure < Preact::Component::Base
        render do
          DIV 'TopPure'
        end
      end

      module Deeply
        module Nested
          class Pure < Preact::Component::Base
            render do
              DIV 'Deeply::Nested::Pure'
            end
          end
        end
      end

      class TopFunction < Preact::FunctionComponent::Base
        render do
          DIV 'TopFunction'
        end
      end

      module VeryDeeply
        module VeryNested
          class VeryFunction < Preact::FunctionComponent::Base
            render do
              DIV 'VeryDeeply::VeryNested::VeryFunction'
            end
          end
        end
      end
    end

    @test_anchor = @doc.find('#test_anchor')
  end

  it 'can resolve components from a top level Preact::Component' do
    @doc.evaluate_ruby do
      class TestComponent < Preact::Component::Base
        render do
          TopPure()
          Deeply::Nested::Pure()
          TopFunction()
          VeryDeeply::VeryNested::VeryFunction()
          TopNativeComponent()
          NestedNative.AnotherComponent()
          NestedNative::AnotherComponent()
        end
      end

      Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
    end
    html = @test_anchor.html
    expect(html).to include('TopPure')
    expect(html).to include('Deeply::Nested::Pure')
    expect(html).to include('TopFunction')
    expect(html).to include('VeryDeeply::VeryNested::VeryFunction')
    expect(html).to include('TopNativeComponent')
    expect(html).to include('NestedNative.AnotherComponent')
  end

  it 'can resolve components from a nested Preact::Component' do
    @doc.evaluate_ruby do
      module Super
        module SuperDeeply
          module SuperNested
            class TestComponent < Preact::Component::Base
              render do
                TopPure()
                Deeply::Nested::Pure()
                TopFunction()
                VeryDeeply::VeryNested::VeryFunction()
                TopNativeComponent()
                NestedNative.AnotherComponent()
                NestedNative::AnotherComponent()
              end
            end
          end
        end
      end
      Isomorfeus::TopLevel.mount_component(Super::SuperDeeply::SuperNested::TestComponent, {}, '#test_anchor')
    end

    html = @test_anchor.html
    expect(html).to include('TopPure')
    expect(html).to include('Deeply::Nested::Pure')
    expect(html).to include('TopFunction')
    expect(html).to include('VeryDeeply::VeryNested::VeryFunction')
    expect(html).to include('TopNativeComponent')
    expect(html).to include('NestedNative.AnotherComponent')
  end

  it 'can resolve components from a top level Preact::Component DIV element' do
    @doc.evaluate_ruby do
      class TestComponent < Preact::Component::Base
        render do
          DIV do
            TopPure()
            Deeply::Nested::Pure()
            TopFunction()
            VeryDeeply::VeryNested::VeryFunction()
            TopNativeComponent()
            NestedNative.AnotherComponent()
            NestedNative::AnotherComponent()
          end
        end
      end

      Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
    end
    html = @test_anchor.html
    expect(html).to include('TopPure')
    expect(html).to include('Deeply::Nested::Pure')
    expect(html).to include('TopFunction')
    expect(html).to include('VeryDeeply::VeryNested::VeryFunction')
    expect(html).to include('TopNativeComponent')
    expect(html).to include('NestedNative.AnotherComponent')
  end

  it 'can resolve components from a nested Preact::Component DIV Element' do
    @doc.evaluate_ruby do
      module Super
        module SuperDeeply
          module SuperNested
            class TestComponent < Preact::Component::Base
              render do
                DIV do
                  TopPure()
                  Deeply::Nested::Pure()
                  TopFunction()
                  VeryDeeply::VeryNested::VeryFunction()
                  TopNativeComponent()
                  NestedNative.AnotherComponent()
                  NestedNative::AnotherComponent()
                end
              end
            end
          end
        end
      end
      Isomorfeus::TopLevel.mount_component(Super::SuperDeeply::SuperNested::TestComponent, {}, '#test_anchor')
    end

    html = @test_anchor.html
    expect(html).to include('TopPure')
    expect(html).to include('Deeply::Nested::Pure')
    expect(html).to include('TopFunction')
    expect(html).to include('VeryDeeply::VeryNested::VeryFunction')
    expect(html).to include('TopNativeComponent')
    expect(html).to include('NestedNative.AnotherComponent')
  end

  it 'can resolve components from a top level Preact::FunctionComponent' do
    @doc.evaluate_ruby do
      class TestComponent < Preact::FunctionComponent::Base
        render do
          TopPure()
          Deeply::Nested::Pure()
          TopFunction()
          VeryDeeply::VeryNested::VeryFunction()
          TopNativeComponent()
          NestedNative.AnotherComponent()
          NestedNative::AnotherComponent()
        end
      end

      Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
    end
    html = @test_anchor.html
    expect(html).to include('TopPure')
    expect(html).to include('Deeply::Nested::Pure')
    expect(html).to include('TopFunction')
    expect(html).to include('VeryDeeply::VeryNested::VeryFunction')
    expect(html).to include('TopNativeComponent')
    expect(html).to include('NestedNative.AnotherComponent')
  end

  it 'can resolve components from a nested Preact::FunctionComponent' do
    @doc.evaluate_ruby do
      module Super
        module SuperDeeply
          module SuperNested
            class TestComponent < Preact::FunctionComponent::Base
              render do
                TopPure()
                Deeply::Nested::Pure()
                TopFunction()
                VeryDeeply::VeryNested::VeryFunction()
                TopNativeComponent()
                NestedNative.AnotherComponent()
                NestedNative::AnotherComponent()
              end
            end
          end
        end
      end
      Isomorfeus::TopLevel.mount_component(Super::SuperDeeply::SuperNested::TestComponent, {}, '#test_anchor')
    end

    html = @test_anchor.html
    expect(html).to include('TopPure')
    expect(html).to include('Deeply::Nested::Pure')
    expect(html).to include('TopFunction')
    expect(html).to include('VeryDeeply::VeryNested::VeryFunction')
    expect(html).to include('TopNativeComponent')
    expect(html).to include('NestedNative.AnotherComponent')
  end

  it 'can resolve function components from within the same module' do
    @doc.evaluate_ruby do
      module ExampleFunction
        class AComponent < Preact::FunctionComponent::Base
          render do
            DIV "AComponent"
          end
        end
      end

      module ExampleFunction
        class AnotherComponent < Preact::FunctionComponent::Base
          render do
            DIV "AnotherComponent"
            AComponent()
          end
        end
      end
      Isomorfeus::TopLevel.mount_component(ExampleFunction::AnotherComponent, {}, '#test_anchor')
    end

    html = @test_anchor.html
    expect(html).to include('AnotherComponent')
    expect(html).to include('AComponent')
  end

  it "can resolve a ruby component in favor of a native component even when they have have the same name" do
    expect(@doc.html).to include('YetAnother::Switch rendered')
  end
end
