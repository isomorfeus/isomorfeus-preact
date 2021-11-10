require 'bundler'
require 'bundler/cli'
require 'bundler/cli/exec'
require 'fileutils'

require_relative 'lib/preact/version'

task :node_modules do
  system("npm install")
end

task :specs do
  puts <<~'ASCII'
  _____                     _
 |  __ \                   | |
 | |__) | __ ___  __ _  ___| |_
 |  ___/ '__/ _ \/ _` |/ __| __|
 | |   | | |  __/ (_| | (__| |_
 |_|   |_|  \___|\__,_|\___|\__|

  ASCII
  pwd = Dir.pwd
  Dir.chdir('test_app_preact')
  FileUtils.rm_f('Gemfile.lock')
  Bundler.with_unbundled_env do
    system('bundle install')
    if Gem.win_platform?
      raise unless system('bundle exec rspec')
    else
      raise unless system('THREADS=4 WORKERS=1 bundle exec rspec')
    end
  end
  Dir.chdir(pwd)
end

task :push_packages do
  Rake::Task['push_packages_to_rubygems'].invoke
  Rake::Task['push_packages_to_github'].invoke
end

task :push_packages_to_rubygems do
  system("gem push isomorfeus-preact-#{Preact::VERSION}.gem")
end

task :push_packages_to_github do
  system("gem push --key github --host https://rubygems.pkg.github.com/isomorfeus isomorfeus-preact-#{Preact::VERSION}.gem")
end

task :push do
  system("git push github")
  system("git push gitlab")
  system("git push bitbucket")
  system("git push gitprep")
end

task :default => :specs
