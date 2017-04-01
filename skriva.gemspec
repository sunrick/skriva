$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "skriva/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "skriva"
  s.version     = Skriva::VERSION
  s.authors     = ["Rickard Sunden"]
  s.email       = ["rickard.sunden@outlook.com"]
  s.homepage    = "https://github.com/sunrick/skriva"
  s.summary     = "Static blog implementation for developers."
  s.description = "Static blog implementation for developers that uses markdown."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.2"
  s.add_dependency "redcarpet", "~> 3.4.0"
  s.add_dependency "rouge", "~> 2.0.7"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry"

end
