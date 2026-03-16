# frozen_string_literal: true

require_relative 'lib/legion/extensions/cognitive_weathering/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-cognitive-weathering'
  spec.version       = Legion::Extensions::CognitiveWeathering::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'LEX Cognitive Weathering'
  spec.description   = 'Models long-term cognitive wear from sustained workloads based on allostatic load theory'
  spec.homepage      = 'https://github.com/LegionIO/lex-cognitive-weathering'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']      = spec.homepage
  spec.metadata['source_code_uri']   = 'https://github.com/LegionIO/lex-cognitive-weathering'
  spec.metadata['documentation_uri'] = 'https://github.com/LegionIO/lex-cognitive-weathering'
  spec.metadata['changelog_uri']     = 'https://github.com/LegionIO/lex-cognitive-weathering'
  spec.metadata['bug_tracker_uri']   = 'https://github.com/LegionIO/lex-cognitive-weathering/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob('{lib,spec}/**/*') + %w[lex-cognitive-weathering.gemspec Gemfile LICENSE README.md]
  end
  spec.require_paths = ['lib']
  spec.add_development_dependency 'legion-gaia'
end
