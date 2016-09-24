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

# in rails >= 4 it would go like this:
module ActiveRecord
  # = Active Record \Relation
  class Relation
    def cache_key(timestamp_column = :updated_at)
      @cache_keys ||= {}
      # Rem 1: why use connection.execute instead of doing collection.select because of an order. if you using some order on your scope
      # then columns you using to order must appear in the GROUP BY clause or be used in an aggregate function or you will get an error
      # Rem 2: we need to add select( cache_columns ) explicitly because if relation has includes it might transform columns to aliases
      @cache_keys[timestamp_column] ||= connection.execute(
          "SELECT md5(string_agg( t.cc_#{timestamp_column}||t.cc_id, '') ) as cache_key
                      FROM (#{ select( [timestamp_column, :id].map{|cc| "#{table_name}.#{cc}::text as cc_#{cc}" } ).try(:to_sql) }) t" )[0]['cache_key']
    end
  end
end
