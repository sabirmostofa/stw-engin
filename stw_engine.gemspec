$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "stw_engine/version"
require 'net/http'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "stw_engine"
  s.version     = StwEngine::VERSION
  s.authors     = ["Sabirul Mostofa"]
  s.email       = ["sabirmostofa@gmail.com"]
  s.homepage    = "http://shrinktheweb.com"
  s.summary     = "Shows thumbnail from the shrinktheweb."
  s.description = "Show thumbnail from shrinktheweb"

  s.files = `git ls-files`.split($/)
  s.test_files = Dir["test/**/*"]

  #s.add_dependency "rails", "~> 3.2.15"
   s.add_dependency "nokogiri"

  s.add_development_dependency "sqlite3"
end
