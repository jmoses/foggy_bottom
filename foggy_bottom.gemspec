# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "foggy_bottom/version"

Gem::Specification.new do |s|
  s.name        = "foggy_bottom"
  s.version     = FoggyBottom::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jon Moses"]
  s.email       = ["jon@burningbush.us"]
  s.homepage    = ""
  s.summary     = %q{Ruby API wrapper for FogBugz}
  s.description = %q{It wraps the FogBugz API.}

  #s.rubyforge_project = "foggy_bottom"
  s.add_dependency('nokogiri')
  s.add_dependency('activemodel')
  #s.add_dependency('hirb')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
