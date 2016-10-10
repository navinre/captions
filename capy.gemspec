# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capy/version'

Gem::Specification.new do |spec|
  spec.name          = "capy"
  spec.version       = Capy::VERSION
  spec.authors       = ["navin"]
  spec.email         = ["navin@amagi.com"]

  spec.summary       = %q{A Subtitle Editor written in Ruby}
  spec.description   = %q{ A Subtitle Editor written in Ruby. Capy can read/modify/export any subtitle from one format to another }
  spec.homepage      = "https://github.com/navinre/capy"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
