$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "prediction_io/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "prediction_io"
  s.version     = PredictionIo::VERSION.dup
  s.authors     = ["Antonio C Nalesso"]
  s.email       = ["acnalesso@yahoo.co.uk"]
  s.homepage    = "http://prediction.io/"
  s.summary     = " Predicts, recommends, or personalise data for users."
  s.description = "PredictionIO is an open source machine learning server for software developers
                   to create predictive features, such as personalization,
                   recommendation and content discovery."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.0.0"

  s.add_development_dependency "mongoid"
  s.add_development_dependency "rspec"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "activeresource"
end
