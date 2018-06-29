# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sdk/telefonica/version'

Gem::Specification.new do |spec|
  spec.name          = "sdk-telefonica"
  spec.version       = Sdk::Telefonica::VERSION
  spec.authors       = ["Click2Cloud Inc."]
  spec.email         = ["contact@click2cloud.net"]

  spec.summary       = %q{Telefonica sdk provider gem}
  spec.description   = %q{Telefonica sdk provider gem.}

  spec.files         = Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_dependency 'fog-core',  '~> 1.40'
  spec.add_dependency 'fog-json',  '>= 1.0'
  spec.add_dependency 'ipaddress', '>= 0.8'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency "mime-types"
  spec.add_development_dependency "mime-types-data"
  spec.add_development_dependency 'rake',    '~> 10.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'shindo',  '~> 0.3'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock',  '~> 1.24.6'
end