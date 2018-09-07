Gem::Specification.new do |spec|
  spec.name        = "flakes"
  spec.version     = "0.4.0"
  spec.date        = "2018-09-07"
  spec.summary     = "flakes"
  spec.description = "business logic framework for rails"
  spec.authors     = ["Manuel Schiner"]
  spec.email       = "maschiner@maschiner.com"
  spec.files       = ["lib/flakes.rb"]
  spec.homepage    = "https://github.com/maschiner/flakes"
  spec.license     = "MIT"

  spec.add_runtime_dependency "rails"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
end
