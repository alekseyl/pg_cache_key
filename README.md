# PgCacheKey
Attention! This gem intend to use only with PostrgreSQL, so it will not work other ways, BUT if your database have some 
aggregation function you can get idea and create your own version of it.

Simple replace for cache_key for collections to make it very fast. 
It's optimizing code near fragment_cache_key, replacing collection instatination with DB aggregation.

It respects all aspects of collection properties including order, limits, offsets and so.

Also comparing to rails 5 solution for collection cache key this one will not need to throw away all sub-collection caches 
when any elements of the whole collection updates. 

Rem: mention my solution in https://github.com/rails/rails/issues/26330 

# Benchmark
the numbers I personally get while comparing with rails 4.2 implementation of cache_key are:
 
Complex model
without includes: 10 items in collection ~ x1.3 faster, 20 ~ 1.55, 50 ~ x2, 1000 ~ x15

with includes:  10 items in collection ~ x5+ faster, 20 ~ x5-6+, 50 ~ x8.5, 1000 ~ x35

less complex model:

without includes: 10 items in collection ~ x1.2 faster, 20 ~ x1.25, 50 ~ x1.5, 1000 ~ x7.4

with includes: 10 items in collection ~ x3.6 faster, 20 ~ x4, 50 ~ x5.6, 1000 ~ x32

Of course this is not the numbers for whole page rendering, but it's noticeable. 

Try it yourself.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pg_cache_key'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pg_cache_key

## Usage

It works out of the box for system uses pg. 

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alekseyl/pg_cache_key.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

