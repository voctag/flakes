Gem::Specification.new do |spec|
  spec.name        = "flakes"
  spec.version     = "0.1.0"
  spec.date        = "2015-07-30"
  spec.summary     = "flakes"
  spec.description = "hexagonal framework for rails"
  spec.authors     = ["Manuel Schiner"]
  spec.email       = "maschiner@maschiner.com"
  spec.files       = ["lib/flakes.rb"]
  spec.homepage    = "http://rubygems.org/gems/flakes"
  spec.license     = "MIT"

  spec.add_runtime_dependency "activemodel"
  spec.add_runtime_dependency "activejob"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
