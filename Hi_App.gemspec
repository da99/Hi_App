# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "Hi_App/version"

Gem::Specification.new do |s|
  s.name        = "Hi_App"
  s.version     = Hi_App::VERSION
  s.authors     = ["da99"]
  s.email       = ["i-hate-spam-45671204@mailinator.com"]
  s.homepage    = ""
  s.summary     = %q{Create a "Hello, World!" web app.}
  s.description = %q{
  Uses Sinatra and Passenger to create a starter
  web app. Meant mainly for development.
  }

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'bacon'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'Bacon_Colored'
  s.add_development_dependency 'pry'
  
  s.add_runtime_dependency 'Exit_0'
  s.add_runtime_dependency 'sinatra'
  s.add_runtime_dependency 'thin'
  
end
