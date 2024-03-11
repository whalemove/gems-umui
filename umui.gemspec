# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'umui/version'

Gem::Specification.new do |spec|
  spec.name          = "umui"
  spec.version       = Umui::VERSION
  spec.authors       = ["gui.hu"]
  spec.email         = ["gui.hu@optilinkuniversal.com"]
  
  spec.summary       = %q{The unified user management interface}
  spec.description   = %q{The gem support user interface for other system, such as register , login , logout , validate token and so on}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "activeresource", '4.0.0'
  spec.add_development_dependency "dalli", '2.7.4'
  spec.add_development_dependency "jwt", '1.4.1'
  
end
