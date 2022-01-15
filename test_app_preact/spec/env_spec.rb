require 'spec_helper'

RSpec.describe 'Execution Environment' do
  before do
    @page = visit('/')
  end

  it 'is set to "production"' do
    element = @page.wait_for_selector('#test_anchor')
    expect(element).to be_truthy
    result = @page.eval_ruby do
      Isomorfeus.env
    end
    expect(result).to eq('test')
    result = @page.eval_ruby do
      Isomorfeus.test?
    end
    expect(result).to be true
    result = @page.eval_ruby do
      Isomorfeus.development?
    end
    expect(result).to be false
    result = @page.eval_ruby do
      Isomorfeus.production?
    end
    expect(result).to be false
  end

  it 'detects execution environment' do
    element = @page.wait_for_selector('#test_anchor')
    expect(element).to be_truthy
    result = @page.eval_ruby do
      Isomorfeus.on_browser?
    end
    expect(result).to be true
    result = @page.eval_ruby do
      Isomorfeus.on_ssr?
    end
    expect(result).to be false
    result = @page.eval_ruby do
      Isomorfeus.on_mobile?
    end
    expect(result).to be false
    result = @page.eval_ruby do
      on_browser?
    end
    expect(result).to be true
    result = @page.eval_ruby do
      on_ssr?
    end
    expect(result).to be false
    result = @page.eval_ruby do
      on_mobile?
    end
    expect(result).to be false
  end
end
