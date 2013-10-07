# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tele42/version'

Gem::Specification.new do |spec|
  spec.name          = "tele42"
  spec.version       = Tele42::VERSION
  spec.authors       = ["Alexander Simonov"]
  spec.email         = ["alex@simonov.me"]
  spec.description   = %q{42 Telecom SMS-MT API wrapper}
  spec.summary       = %q{42 Telecom SMS-MT API wrapper}
  spec.homepage      = "https://github.com/dotpromo/tele42"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
  spec.add_dependency('faraday')
end
