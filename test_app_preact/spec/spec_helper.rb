ENV['NODE_PATH'] = File.join(File.expand_path('..', __dir__), 'node_modules')
ENV['RACK_ENV'] = 'test'
require 'bundler/setup'
require 'rspec'
require 'rspec/expectations'
require 'isomorfeus-puppetmaster'
require_relative '../test_app_app'

Isomorfeus::Puppetmaster.download_path = File.join(Dir.pwd, 'download_path_tmp')
Isomorfeus::Puppetmaster.app = TestAppApp
Isomorfeus::Puppetmaster.boot_app

RSpec.configure do |config|
  config.include Isomorfeus::Puppetmaster::DSL
  config.include Isomorfeus::PreactViewHelper
end
