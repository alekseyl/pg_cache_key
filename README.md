#Attention! 

This gem intend to use only with PostrgreSQL >= 9.1, so it will not work other ways, BUT if your database have some 
aggregation function you can get idea and create your own version of it.

# Внимашка (рус)

Данный gem работает только с PostrgreSQL >= 9.1, НО если у вас есть потребность в аналоге для другой БД вы 
легко можете, скопировав код, поменять все что нужно. 

# PgCacheKey
Simple replace for cache_key for collections to make it very fast. 
It's optimizing code near fragment_cache_key, replacing collection and it's includes instatination with DB aggregation.

It respects all aspects of collection properties including order, limits, offsets and so.

Also comparing to rails 5 solution for collection cache key this one will not need to throw away all sub-collection caches 
when any elements of the table updates. 

Rem: I mention my solution in https://github.com/rails/rails/issues/26330 

# PgCacheKey (рус)

Назначение данного gem'а - ускорение генрации ключей кеша коллекций путем переноса генерации на плечи БД, что экономит на инстантинации коллекции и всех ее зависимостей. Особенно выгодно может быть использование в рельсах до 4.2 включительно, потому что в 4-х рельсах для генерации ключей коллекции она превращается в массив, т.е. инстанцируется, включая все связные коллекции.  

PgCacheKey зависит только от подмножества используемых записей и их порядка, поэтому в отличие от collection_cache_key в 5-х 
рельсах кеши всех подколлекций не летят в топку при изменении одного элемента в таблице.  

Rem: Данное решение было упомянуто мной в https://github.com/rails/rails/issues/26330 

# Benchmark
the numbers I personally get while comparing with rails 4.2 implementation of cache_key are:
 
Complex model
without includes: 10 items in collection ~ x1.3 faster, 20 ~ 1.55, 50 ~ x2, 1000 ~ x15

with includes:  10 items in collection ~ x5+ faster, 20 ~ x5-6+, 50 ~ x8.5, 1000 ~ x35

less complex model:

without includes: 10 items in collection ~ x1.2 faster, 20 ~ x1.25, 50 ~ x1.5, 1000 ~ x7.4

with includes: 10 items in collection ~ x3.6 faster, 20 ~ x4, 50 ~ x5.6, 1000 ~ x32

Benchmark code can look like this:

```ruby
def cache_key_vs_db_checksum(n, model_or_relation = Request)
      Benchmark.ips do |bm|

        bm.report(:direct_cache_key_rnd) {  ApplicationController.new.fragment_cache_key( model_or_relation.limit(n).random().old_cache_key ) ; :done }
        bm.report(:checksummed_cache_key_rnd ) { ApplicationController.new.fragment_cache_key( model_or_relation.limit(n).random().new_cash_key ); :done }

        bm.compare!
      end

    end
```
Rem: since gem replaces cache_key, this code will need some changes to benchmark on your machine 

Of course this is not the numbers for whole page rendering, but it's noticeable. 

One of my real page goes from 0.8+ sec, for largest available pagination, to 0.6 sec per page 

To get your numbers try it yourself!

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
It works out of the box. Plz don't use in on collection greater than 50K your DB will suffer.

## Как использовать

По идее работает само из коробки, но если будут траблы - пишите. Не стоит использовать для получаения кеш ключей коллекций больше 50К элементов, БДшка будет мучаться.

## Testing
rake spec

Tested only query string for simple case. In your project you may test it on more specific query. 

## Testing(рус)
rake spec 
Тестируется только строка запроса для самого простого случая + добавление метода в активрекорд релейшен. 
Стабильность на сложных запросах специфических для вашего приложения можете добавить в свои тесты.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alekseyl/pg_cache_key.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

