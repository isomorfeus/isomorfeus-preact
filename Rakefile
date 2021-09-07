require 'bundler'
require 'bundler/cli'
require 'bundler/cli/exec'
require 'fileutils'

require_relative 'lib/preact/version'

task :default => :specs

task :node_modules do
  system("npm install")
end

task :specs => :node_modules do
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
  FileUtils.rm_rf('spec')
  FileUtils.cp_r('../common_spec', 'spec')
  FileUtils.rm_rf('public/assets')
  if Gem.win_platform?
    Bundler.with_original_env do
      system('bundle install')
      system('bundle exec rspec')
    end
  else  
    Bundler.with_original_env do
      system('bundle install')
      system('THREADS=4 WORKERS=1 bundle exec rspec')
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

task :push_to_repos do
  system("git push github")
  system("git push gitlab")
  system("git push bitbucket")
end
