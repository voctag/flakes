Gem::Specification.new do |spec|
  spec.name        = "flakes"
  spec.version     = "0.5.3"
  spec.date        = "2021-04-22"
  spec.summary     = "flakes"
  spec.description = "business logic framework for rails"
  spec.authors     = ["Manuel Schiner"]
  spec.email       = "maschiner@maschiner.com"
  spec.files       = ["lib/flake.rb", "lib/flake/error.rb"]
  spec.homepage    = "https://github.com/voctag/flakes"
  spec.license     = "MIT"

  spec.add_runtime_dependency "rails", '~> 6.1.3', '>= 6.1.3.1'

  spec.add_development_dependency "bundler", "~> 1.16.4"
  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "rubocop", "~> 0.58"
end
