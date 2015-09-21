$:.push File.expand_path("../lib", __FILE__)

require 'weak_headers/version'

Gem::Specification.new do |spec|
  spec.name          = 'weak_headers'
  spec.version       = WeakHeaders::VERSION
  spec.authors       = ['Tadayuki Onishi']
  spec.email         = ['tt.tanishi100@gmail.com']
  spec.summary       = 'Add a validation headers filter to your controller.'
  spec.homepage      = 'https://github.com/kenchan0130/weak_headers'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 3.2.11'
  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake'
end
