require 'rspec'
require 'active_record'
require 'pg_cache_key'

describe PgCacheKey do
  let(:mock_class) { build_mock_class }
  before(:all) {create_mock_table}
  after(:all){drop_mock_table}

  it 'should must add cache_key to relation and generate specific raw_sql' do
    expect( mock_class.all ).to respond_to(:cache_key, :cache_key_raw_sql)
    expect(mock_class.all.cache_key_raw_sql).to eq("SELECT md5(string_agg( t.ckc_updated_at||t.ckc_id, '') ) as cache_key FROM (SELECT pg_cache_key_mock_table.updated_at::text as ckc_updated_at, pg_cache_key_mock_table.id::text as ckc_id FROM \"pg_cache_key_mock_table\") t")
  end

  def build_mock_class
    Class.new(ActiveRecord::Base) do
      self.table_name = :pg_cache_key_mock_table
      # reset_column_information
    end
  end

  def create_mock_table
    ActiveRecord::Base.establish_connection(
        adapter:  'sqlite3',
        database: ':memory:'
    )
    ActiveRecord::Base.connection.create_table :pg_cache_key_mock_table  do |t|
      t.timestamps
    end
  end

  def drop_mock_table
    ActiveRecord::Base.connection.drop_table :pg_cache_key_mock_table
  end
end