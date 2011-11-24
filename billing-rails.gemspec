$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "billing/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "billing-rails"
  s.version     = Billing::Rails::VERSION
  s.authors     = ["Adam Hawkins"]
  s.email       = ["adman1965@gmail.com"]
  s.homepage    = "https://github.com/adman65/billing-rails"
  s.summary     = "Extension of Billing for use in Rails applications"
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "billing"
  s.add_dependency "rails", "~> 3.0.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "simplecov"
end
