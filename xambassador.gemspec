# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "xambassador/version"

Gem::Specification.new do |spec|
  spec.name = "xambassador"
  spec.version = Xambassador::VERSION
  spec.summary = "Gem summary"
  spec.description = "Gem description"
  spec.authors = ["Rather Blue"]
  spec.email = "ratherblue@gmail.com"
  spec.files = Dir["lib/**/*"]
  spec.homepage = "http://github.com/ratherblue/xambassador"
  spec.license = "Apache 2.0"
  spec.require_paths = ["lib"]

  spec.add_development_dependency("rake", "~> 10.0")
  spec.add_development_dependency("minitest")
  spec.add_development_dependency("minitest-reporters", "1.1.7")
  spec.add_development_dependency("rubocop", "~> 0.37.2")
  spec.add_development_dependency("sinatra", "~> 1.4.7")
  spec.add_development_dependency("webmock", "~> 1.24.2")

  spec.add_dependency("octokit", "~> 4.3.0")
  spec.add_dependency("renegade", "0.1.51")
  spec.add_dependency("uri_template", "0.7.0")
  spec.add_dependency("nokogiri", "1.6.7.2")
end
