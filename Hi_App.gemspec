# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "Hi_App/version"

Gem::Specification.new do |s|
  s.name        = "Hi_App"
  s.version     = Hi_App::VERSION
  s.authors     = ["da99"]
  s.email       = ["i-hate-spam-45671204@mailinator.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "bacon"
  s.add_development_dependency "rake"
  s.add_development_dependency 'Bacon_Colored'
  
  # s.rubyforge_project = "Hi_App"
  # specify any dependencies here; for example:
  s.add_runtime_dependency 'Unified_IO'
  
end
