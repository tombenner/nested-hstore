require File.expand_path('../lib/nested_hstore/version', __FILE__)

Gem::Specification.new do |s|
  s.authors       = ['Tom Benner']
  s.email         = ['tombenner@gmail.com']
  s.description = s.summary = %q{Store nested hashes and other types in ActiveRecord hstores}
  s.homepage      = 'https://github.com/tombenner/nested-hstore'

  s.files         = Dir['{lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']
  s.name          = 'nested-hstore'
  s.require_paths = ['lib']
  s.version       = NestedHstore::VERSION
  s.license       = 'MIT'

  s.add_dependency 'activerecord'
  s.add_dependency 'activerecord-postgres-hstore'
  s.add_dependency 'activesupport'
end
