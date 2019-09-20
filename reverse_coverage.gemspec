# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'reverse_coverage/version'

Gem::Specification.new do |spec|
  spec.name          = 'reverse_coverage'
  spec.version       = ReverseCoverage::VERSION
  spec.summary       = 'Reverse coverage'
  spec.description   = 'Statistics on specs coverage'
  spec.license       = 'MIT'
  spec.authors       = ['Daniele Palombo', 'Mattia Roccoberton']
  spec.email         = ['danielepalombo@nebulab.it', 'mattiaroccoberton@nebulab.it']
  spec.homepage      = 'https://github.com/nebulab/reverse_coverage'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rspec', '~> 3.8'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'pry', '~> 0.12.2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
