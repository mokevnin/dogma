# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dogma/version"

Gem::Specification.new do |s|
  s.name        = "dogma"
  s.version     = Dogma::VERSION
  s.authors     = ["Mokevnin Kirill"]
  s.email       = ["mokevnin@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{data mapper implementation for ruby}
  s.description = %q{based on doctrine2}

  s.rubyforge_project = "dogma"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "i18n"
  s.add_runtime_dependency "sequel"
end
