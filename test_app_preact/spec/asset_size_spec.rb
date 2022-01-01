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
    puts "Max asset sizes: minified: #{asset.bundle_size/1024}kb, gzip: #{asset.bundle_gz_size/1024}kb"
    expect((asset.bundle_size/1024) < 505).to be true
    expect((asset.bundle_gz_size/1024) < 135).to be true
  end
end
