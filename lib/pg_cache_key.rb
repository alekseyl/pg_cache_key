require "pg_cache_key/version"

# In rails 5 it can be
# module ActiveRecord
#   module CollectionCacheKey
#     def collection_cache_key(collection = all, timestamp_column = :updated_at) # :nodoc:
#       # why use connection.execute instead of doing collection.select because of an order. if you using some order on your scope
#       # then columns you using to order must appear in the GROUP BY clause or be used in an aggregate function or you will get an error
#       cache_columns = [timestamp_column, :id]
#       @cache_keys ||= {}
#       # we need to add select cache_columns explicitly because if relation has includes it might transform columns to aliases
#       @cache_keys[timestamp_column] ||= connection.execute( "SELECT md5(string_agg( #{cache_columns.map{|fld| "\"t\".\"#{fld}\"::text" }.join('||')}, '') ) as cache_key
#                             FROM (#{ collection.select(cache_columns).try(:to_sql) }) t" )[0]['cache_key']
#     end
#   end
# end

module PgCacheKey
  def cache_key_raw_sql( timestamp_column = :updated_at )
    "SELECT md5(string_agg( t.ckc_#{timestamp_column}||t.ckc_id, '') ) as cache_key \
FROM (#{ select( [timestamp_column, :id].map{|ckc| "#{table_name}.#{ckc}::text as ckc_#{ckc}" } ).try(:to_sql) }) t"
  end
end

# Actually this all depends on retrieve_cache_key(key) from active_support:
# def retrieve_cache_key(key)
#   case
#     when key.respond_to?(:cache_key) then key.cache_key
#     when key.is_a?(Array)            then key.map { |element| retrieve_cache_key(element) }.to_param
#     when key.respond_to?(:to_a)      then retrieve_cache_key(key.to_a)
#     else                                  key.to_param
#   end.to_s
# end
# in rails 4 there is no cache_key in relations so if we deliver relation as key in rails 4 it will convert to array first
# in rails 5 there is cache_key, the method below is copy+paste from rails 5 except it doesn't use rails 5 collection_cache_key,
# and use it's own algorithm for cache_key
module ActiveRecord
  # = Active Record \Relation
  class Relation
    include PgCacheKey

    def cache_key(timestamp_column = :updated_at)
      @cache_keys ||= {}
      # Rem 1: why use connection.execute instead of doing collection.select because of an order. if you using some order on your scope
      # then columns you using to order must appear in the GROUP BY clause or be used in an aggregate function or you will get an error
      # Rem 2: we need to add select( cache_columns ) explicitly because if relation has includes it might transform columns to aliases
      # and we must also select them as uniq-aliase so PG wouldn't be confused
      # 'ckc' means cache key column :)
      @cache_keys[timestamp_column] ||= connection.execute( cache_key_raw_sql(timestamp_column) )[0]['cache_key']
    end

  end
end
