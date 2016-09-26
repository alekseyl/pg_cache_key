require 'rspec'
require 'pg_cache_key'

RSpec.configure do |config|
  config.color_enabled = true
  ActiveRecord::Base.establish_connection(
      adapter:  'sqlite3',
      database: ':memory:'
  )
end