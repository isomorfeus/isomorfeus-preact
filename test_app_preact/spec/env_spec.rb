require 'spec_helper'

RSpec.describe 'Execution Environment' do
  before do
    @doc = visit('/')
  end

  it 'is set to "production"' do
    node = @doc.wait_for('#test_anchor')
    expect(node).to be_truthy
    result = @doc.evaluate_ruby do
      Isomorfeus.env
    end
    expect(result).to eq('test')
    result = @doc.evaluate_ruby do
      Isomorfeus.test?
    end
    expect(result).to be true
    result = @doc.evaluate_ruby do
      Isomorfeus.development?
    end
    expect(result).to be false
    result = @doc.evaluate_ruby do
      Isomorfeus.production?
    end
    expect(result).to be false
  end

  it 'detects execution environment' do
    node = @doc.wait_for('#test_anchor')
    expect(node).to be_truthy
    result = @doc.evaluate_ruby do
      Isomorfeus.on_browser?
    end
    expect(result).to be true
    result = @doc.evaluate_ruby do
      Isomorfeus.on_ssr?
    end
    expect(result).to be false
    result = @doc.evaluate_ruby do
      Isomorfeus.on_mobile?
    end
    expect(result).to be false
    result = @doc.evaluate_ruby do
      on_browser?
    end
    expect(result).to be true
    result = @doc.evaluate_ruby do
      on_ssr?
    end
    expect(result).to be false
    result = @doc.evaluate_ruby do
      on_mobile?
    end
    expect(result).to be false
  end
end
