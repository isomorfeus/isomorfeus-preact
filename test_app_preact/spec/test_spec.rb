require 'spec_helper'

RSpec.describe 'isomorfeus-asset-manager compiled successfully' do
  it 'and opal code can be executed in the browser' do
    page = visit('/')
    expect(page.eval('1 + 4')).to eq(5)
    expect(page.eval('typeof Opal')).to include('object')
    result = page.eval_ruby do
      1 + 5
    end
    expect(result).to eq(6)
  end
end