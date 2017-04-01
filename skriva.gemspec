$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "skriva/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "skriva"
  s.version     = Skriva::VERSION
  s.authors     = ["Rickard Sunden"]
  s.email       = ["rickard.sunden@outlook.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Skriva."
  s.description = "TODO: Description of Skriva."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.2"

  s.add_development_dependency "sqlite3"
end
