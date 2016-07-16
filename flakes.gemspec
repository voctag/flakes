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

  spec.add_runtime_dependency "activemodel", "~> 5.0"
  spec.add_runtime_dependency "activejob", "~> 5.0"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 11.1"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "rubocop", "~> 0.41"
  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
end
