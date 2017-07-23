# -*- encoding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/lib/shadow_db_credentials/version')

Gem::Specification.new do |spec|
  spec.name          = "shadow_db_credentials"
  spec.summary       = %q{Class that helps to keep database credentials for rails application in private place.}
  spec.description   = %q{Class that helps to keep database credentials for rails application in private place}
  spec.email         = "alexander.shvets@gmail.com"
  spec.authors       = ["Alexander Shvets"]
  spec.homepage      = "http://github.com/shvets/shadow_db_credentials"

  spec.files         = `git ls-files`.split($\)
  #spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  #gemspec.bindir = "bin"
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.version       = ShadowDbCredentials::VERSION
  spec.license       = "MIT"

  
  spec.add_development_dependency "gemspec_deps_gen", ["= 1.1.2"]
  spec.add_development_dependency "gemcutter", ["= 0.7.1"]
  spec.add_development_dependency "thor", ["= 0.19.4"]

end

