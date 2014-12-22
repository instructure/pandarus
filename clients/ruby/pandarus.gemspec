# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pandarus/version'

Gem::Specification.new do |gem|
  gem.authors =       ["Duane Johnson"]
  gem.email =         ["duane@instructure.com"]
  gem.description =   %q{Ruby wrapper for Canvas API}
  gem.summary =       %q{REST APIs}
  gem.homepage =      'https://github.com/instructure/pandarus'
  gem.license =       'MIT'

  gem.files = %w[pandarus.gemspec]
  gem.files += Dir.glob("lib/**/*.rb")
  gem.files += Dir.glob("spec/**/*")
  gem.test_files    = Dir.glob("spec/**/*")
  gem.name          = "pandarus"
  gem.require_paths = ["lib"]
  gem.version       = Pandarus::VERSION

  gem.add_development_dependency "rake"
  gem.add_development_dependency "bundler", ">= 1.0.0"
  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "vcr"
  gem.add_development_dependency "pry"

  gem.add_dependency "footrest", '~> 0.5.0'
  gem.add_dependency "activesupport", ">= 3.0.0"
  gem.add_dependency "virtus", ">= 1.0.3"
  gem.add_dependency "inflecto", ">= 0.0.2"
end
