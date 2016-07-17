# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slack_oauth'

Gem::Specification.new do |spec|
  spec.name          = "slack_oauth"
  spec.version       = SlackOauth::VERSION
  spec.authors       = ["m0cchi"]
  spec.email         = ["boom.boom.planet@gmail.com"]

  spec.summary       = %q{Slack OAuth driver.}
  spec.description   = %q{Slack OAuth driver.}
  spec.homepage      = "https://github.com/m0cchi/slack_oauth"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sinatra"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
