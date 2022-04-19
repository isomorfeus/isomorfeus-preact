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
  s.add_dependency 'opal', '>= 1.4.0', '< 1.6.0'
  s.add_dependency 'opal-activesupport', '~> 0.3.3'
  s.add_dependency 'opal-zeitwerk', '~> 0.4.1'
  s.add_dependency 'isomorfeus-asset-manager', '~> 0.14.22'
  s.add_dependency 'isomorfeus-redux', '~> 4.2.0'
  s.add_dependency 'isomorfeus-speednode', '~> 0.5.3'
  s.add_dependency 'zeitwerk', '~> 2.5.4'
  s.add_development_dependency 'isomorfeus-puppetmaster', '~> 0.6.7'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.11'
end
