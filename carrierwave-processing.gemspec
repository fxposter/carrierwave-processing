# -*- encoding: utf-8 -*-
require File.expand_path('../lib/carrierwave-processing/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Pavel Forkert"]
  gem.email         = ["fxposter@gmail.com"]
  gem.description   = %q{Additional processing support for MiniMagick and RMagick}
  gem.summary       = %q{Additional processing support for MiniMagick and RMagick}
  gem.homepage      = "https://github.com/fxposter/carrierwave-processing"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "carrierwave-processing"
  gem.require_paths = ["lib"]
  gem.version       = CarrierWave::Processing::VERSION

  gem.add_dependency 'carrierwave'
end
