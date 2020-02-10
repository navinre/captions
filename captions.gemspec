# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'captions/version'

Gem::Specification.new do |spec|
  spec.name          = "captions"
  spec.version       = Captions::VERSION
  spec.authors       = ["navin"]
  spec.email         = ["navin@amagi.com"]

  spec.summary       = %q{Subtitle Editor and Converter written in Ruby}
  spec.description   = %q{Subtitle Editor and Converter written in Ruby. Captions can read/modify/export subtitles from one format to another }
  spec.homepage      = "https://github.com/navinre/captions"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
end
