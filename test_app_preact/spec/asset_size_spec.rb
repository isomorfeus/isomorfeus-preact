require 'spec_helper'

RSpec.describe 'Asset sizes' do
  after do
    Isomorfeus.env = 'test'
  end

  it 'are within limits' do
    Isomorfeus.env = 'production'
    asset = Isomorfeus.assets['web.js']
    asset.instance_variable_set(:@undled, false)
    a = Isomorfeus::AssetManager.new
    a.transition('web.js', asset, analyze: true)
    puts "Max asset sizes: minified: #{asset.bundle.size/1024}kb"
    expect((asset.bundle.size/1024) < 515).to be true
  end
end
