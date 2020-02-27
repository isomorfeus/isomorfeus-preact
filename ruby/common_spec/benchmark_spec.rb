require 'spec_helper'

RSpec.describe 'Component benchmarks' do
  it 'Load Time' do
    doc = visit('/')
    doc.wait_for('#test_anchor')
    react_lt, react_rt, redux_rt, app_lt = doc.evaluate_ruby do
      [IR_LOAD_TIME, IR_REQUIRE_TIME, IX_REQUIRE_TIME, APP_LOAD_TIME]
    end
    puts "isomorfeus-redux require time: #{redux_rt}ms"
    puts "isomorfeus-react require time: #{react_rt}ms"
    puts "isomorfeus-react load time: #{react_lt}ms"
    puts "application load_time: #{app_lt}ms"
    expect(app_lt < 500).to be true
  end

  it 'Native DIV Element' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class BenchmarkComponent < React::Component::Base
        render do
          Fragment do
            result = []
            10000.times do
              result << `Opal.global.React.createElement('div', null, 'A')`
            end
            result
          end
        end
      end

      start = Time.now
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Native DIV Elements took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'DIV Element (String param)' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class BenchmarkComponent < React::Component::Base
        render do
          Fragment do
            10000.times do
              DIV "A"
            end
          end
        end
      end

      start = Time.now
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 DIV Elements (String param) took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'DIV Element (String block)' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class BenchmarkComponent < React::Component::Base
        render do
          Fragment do
            10000.times do
              DIV { "A" }
            end
          end
        end
      end

      start = Time.now
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 DIV Elements (String block) took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'Native Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class BenchmarkComponent < React::Component::Base
        render do
          Fragment do
            10000.times do
              NativeComponent()
            end
          end
        end
      end

      start = Time.now
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Native Components took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'Function Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Fun < React::FunctionComponent::Base
        render do
          DIV 'A'
        end
      end
      class BenchmarkComponent < React::Component::Base
        render do
          Fragment do
            10000.times do
              Fun()
            end
          end
        end
      end

      start = Time.now
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Function Components took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'Memo Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Memo < React::MemoComponent::Base
        render do
          DIV 'A'
        end
      end
      class BenchmarkComponent < React::Component::Base
        render do
          Fragment do
            10000.times do
              Memo()
            end
          end
        end
      end

      start = Time.now
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Memo Components took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'React Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Pure < React::Component::Base
        render do
          DIV 'A'
        end
      end
      class BenchmarkComponent < React::Component::Base
        render do
          Fragment do
            10000.times do
              Pure()
            end
          end
        end
      end

      start = Time.now
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 React Components took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'Lucid Func' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Fun < LucidFunc::Base
        render do
          DIV 'A'
        end
      end
      class BenchmarkComponent < LucidApp::Base
        render do
          Fragment do
            10000.times do
              Fun()
            end
          end
        end
      end

      start = Time.now
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Lucid Funcs took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'Lucid Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Lucy < LucidComponent::Base
        render do
          DIV 'A'
        end
      end
      class BenchmarkComponent < LucidApp::Base
        render do
          Fragment do
            10000.times do
              Lucy()
            end
          end
        end
      end

      start = Time.now
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Lucid Components took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'Styled Lucid Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Lucy < LucidComponent::Base
        styles do
          {root: { color: 'black' }}
        end
        render do
          DIV(class_name: styles.root) { 'A' }
        end
      end
      class BenchmarkComponent < LucidApp::Base
        render do
          Fragment do
            10000.times do
              Lucy()
            end
          end
        end
      end

      start = Time.now
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Styled Lucid Components took: #{time}ms"
    expect(time > 0 && time < 1500).to be_truthy
  end

  it 'Themed and Styled Lucid Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Lucy < LucidComponent::Base
        styles do |theme|
          {root: { color: theme.root.color }}
        end
        render do
          DIV(class_name: styles.root) { 'A' }
        end
      end
      class BenchmarkComponent < LucidApp::Base
        theme do
          { root: { color: 'black' }}
        end
        render do
          Fragment do
            10000.times do
              Lucy()
            end
          end
        end
      end

      start = Time.now
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Themed and Styled Lucid Components took: #{time}ms"
    expect(time > 0 && time < 1500).to be_truthy
  end

  it 'LucidMaterial Func' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Fun < LucidMaterial::Func::Base
        render do
          DIV 'A'
        end
      end
      class BenchmarkComponent < LucidMaterial::App::Base
        render do
          Fragment do
            10000.times do
              Fun()
            end
          end
        end
      end

      start = Time.now
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Lucid Material Funcs took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end


  it 'Lucid Material Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Lucy < LucidMaterial::Component::Base
        render do
          DIV 'A'
        end
      end
      class BenchmarkComponent < LucidMaterial::App::Base
        render do
          Fragment do
            10000.times do
              Lucy()
            end
          end
        end
      end

      start = Time.now
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Lucid Material Components took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'Styled Lucid Material Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Lucy < LucidMaterial::Component::Base
        styles do
          {root: { color: 'black' }}
        end
        render do
          DIV(class_name: styles.root) { 'A' }
        end
      end
      class BenchmarkComponent < LucidMaterial::App::Base
        render do
          Fragment do
            10000.times do
              Lucy()
            end
          end
        end
      end

      start = Time.now
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Styled Lucid Material Components took: #{time}ms"
    expect(time > 0 && time < 1500).to be_truthy
  end

  it 'Themed and Styled Lucid Material Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Lucy < LucidMaterial::Component::Base
        styles do |theme|
          {root: { color: theme.root.color }}
        end
        render do
          DIV(class_name: styles.root) { 'A' }
        end
      end
      class BenchmarkComponent < LucidMaterial::App::Base
        theme do
          { root: { color: 'black' }}
        end
        render do
          Fragment do
            10000.times do
              Lucy()
            end
          end
        end
      end

      start = Time.now
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Themed and Styled Lucid Material Components took: #{time}ms"
    expect(time > 0 && time < 2000).to be_truthy
  end
end
