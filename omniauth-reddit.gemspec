# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'omniauth/reddit/version'

Gem::Specification.new do |s|
  s.name                  = 'omniauth-reddit'
  s.version               = OmniAuth::Reddit::VERSION
  s.authors               = ['Simmon Li']
  s.email                 = ['simmon@switchgrowth.com']
  s.summary               = 'Reddit strategy for OmniAuth'
  s.homepage              = 'https://github.com/switchgrowth/omniauth-reddit'
  s.required_ruby_version = '>= 3.0.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'omniauth-oauth2', '~> 1.8'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'webmock'
end
