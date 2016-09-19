require "pg_cache_key/version"

# module ActiveRecord
#   module CollectionCacheKey
#     def collection_cache_key(collection = all, timestamp_column = :updated_at) # :nodoc:
#       # why use connection.execute instead of doing collection.select because of an order. if you using some order on your scope
#       # then columns you using to order must appear in the GROUP BY clause or be used in an aggregate function or you will get an error
#       connection.execute( "SELECT md5(string_agg( #{[timestamp_column, :id].map{|fld| "\"t\".\"#{fld}\"::text" }.join('||')}, '') ) as cache_key
#                       FROM (#{ collection.try(:to_sql) }) t" )[0]['cache_key']
#     end
#   end
# end

module ActiveRecord
  # = Active Record \Relation
  class Relation
    def cache_key(timestamp_column = :updated_at)
      @cache_keys ||= {}
      @cache_keys[timestamp_column] ||= connection.execute( "SELECT md5(string_agg( #{[timestamp_column, :id].map{|fld| "\"t\".\"#{fld}\"::text" }.join('||')}, '') ) as cache_key
                      FROM (#{ try(:to_sql) }) t" )[0]['cache_key']
    end
  end
end