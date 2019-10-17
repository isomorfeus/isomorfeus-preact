# -*- encoding: utf-8 -*-
require_relative 'lib/react/version.rb'

Gem::Specification.new do |s|
  s.name          = 'isomorfeus-react'
  s.version       = React::VERSION

  s.authors       = ['Jan Biedermann']
  s.email         = ['jan@kursator.com']
  s.homepage      = 'http://isomorfeus.com'
  s.summary       = 'React for Opal Ruby.'
  s.license       = 'MIT'
  s.description   = 'Write React Components in Ruby.'

  s.files         = `git ls-files -- {lib,LICENSE,README.md}`.split("\n")
  #s.test_files    = `git ls-files -- {test,s,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.post_install_message = <<~TEXT
  
  isomorfeus-react 16.10.12:
  Breaking changes:
  Server Side Rendering is on by default in the development environment.
  Please enable SSR asset builds in the webpack config of your app or turn SSR off with:
  Isomorfeus.server_side_rendering = false

  TEXT

  s.add_dependency 'oj', '>= 3.8'
  s.add_dependency 'opal', '>= 0.11.0'
  s.add_dependency 'opal-activesupport', '~> 0.3.3'
  s.add_dependency 'opal-autoloader', '~> 0.1.0'
  s.add_dependency 'opal-webpack-loader', '>= 0.9.6'
  s.add_dependency 'isomorfeus-redux', '~> 4.0.16'
  s.add_dependency 'isomorfeus-speednode', '~> 0.2.10'
  s.add_development_dependency 'isomorfeus-puppetmaster', '~> 0.2.9'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.8'
end
