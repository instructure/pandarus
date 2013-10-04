# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'red_panda/version'

Gem::Specification.new do |gem|
  gem.authors =       ["Duane Johnson"]
  gem.email =         ["duane@instructure.com"]
  gem.description =   %q{Ruby wrapper for Canvas API}
  gem.summary =       %q{REST APIs}
  gem.homepage =      'https://github.com/instructure/red_panda'
  gem.license =       'MIT'

  gem.files = %w[red_panda.gemspec]
  gem.files += Dir.glob("lib/**/*.rb")
  gem.files += Dir.glob("spec/**/*")
  gem.test_files    = Dir.glob("spec/**/*")
  gem.name          = "red_panda"
  gem.require_paths = ["lib"]
  gem.version       = RedPanda::VERSION

  gem.add_development_dependency "rake"
  gem.add_development_dependency "bundler", ">= 1.0.0"
  gem.add_development_dependency "rspec", "~> 2.6"
  gem.add_development_dependency "debugger"
  gem.add_development_dependency "pry"

  gem.add_dependency "footrest", "~> 0.2.2"
  gem.add_dependency "activesupport", ">= 3.0.0"
end
