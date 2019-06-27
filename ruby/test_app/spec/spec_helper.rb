ENV['NODE_PATH'] = File.join(File.expand_path('..', __dir__), 'node_modules')
ENV['RACK_ENV'] = 'production'
require 'bundler/setup'
require 'rspec'
require 'rspec/expectations'
require 'isomorfeus-puppetmaster'
require_relative '../test_app_app'

ASSETS_COMPILED ||= system('yarn run production_build')

Isomorfeus::Puppetmaster.download_path = File.join(Dir.pwd, 'download_path_tmp')
Isomorfeus::Puppetmaster.driver = :chromium
Isomorfeus::Puppetmaster.server = :iodine
Isomorfeus::Puppetmaster.app = TestAppApp
Isomorfeus::Puppetmaster.boot_app

RSpec.configure do |config|
  config.include Isomorfeus::Puppetmaster::DSL

  config.after(:suite) do
    STDERR.puts "Calling Iodine.stop"
    Iodine.stop
  end
end

