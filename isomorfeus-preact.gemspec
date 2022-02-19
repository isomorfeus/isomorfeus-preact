# -*- encoding: utf-8 -*-
require_relative 'lib/preact/version.rb'

Gem::Specification.new do |s|
  s.name          = 'isomorfeus-preact'
  s.version       = Preact::VERSION

  s.authors       = ['Jan Biedermann']
  s.email         = ['jan@kursator.com']
  s.homepage      = 'https://isomorfeus.com'
  s.summary       = 'Preact Components for Isomorfeus.'
  s.license       = 'MIT'
  s.description   = 'Write Preact Components in Ruby, including styles and reactive data access.'
  s.metadata      = {
                      "github_repo" => "ssh://github.com/isomorfeus/gems",
                      "source_code_uri" => "https://github.com/isomorfeus/isomorfeus-preact"
                    }
  s.files         = `git ls-files -- lib LICENSE README.md node_modules package.json`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'concurrent-ruby', '~> 1.1.9'
  s.add_dependency 'oj', '~> 3.13.11'
  s.add_dependency 'opal', '~> 1.4.1'
  s.add_dependency 'opal-activesupport', '~> 0.3.3'
  s.add_dependency 'opal-zeitwerk', '~> 0.3.0'
  s.add_dependency 'isomorfeus-asset-manager', '~> 0.14.15'
  s.add_dependency 'isomorfeus-redux', '~> 4.1.18'
  s.add_dependency 'isomorfeus-speednode', '~> 0.5.2'
  s.add_dependency 'dalli', '~> 2.7.11'
  s.add_dependency 'redis', '~> 4.4.0'
  s.add_dependency 'zeitwerk', '~> 2.4.2'
  s.add_development_dependency 'isomorfeus-puppetmaster', '~> 0.6.5'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.10'
end
