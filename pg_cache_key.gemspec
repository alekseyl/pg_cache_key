# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pg_cache_key/version'

Gem::Specification.new do |spec|
  spec.name          = "pg_cache_key"
  spec.version       = PgCacheKey::VERSION
  spec.authors       = ["alekseyl"]
  spec.email         = ["leshchuk@gmail.com"]

  spec.summary       = %q{collection_cache_key replacement for system which uses PG as DB }
  spec.description   = %q{collection_cache_key replacement for system which uses PG as DB, uses PG aggregation functions }
  spec.homepage      = "https://github.com/alekseyl/pg_cache_key"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">=4.1"
  spec.add_dependency "pg"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
