require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "data/database.sqlite3",
  pool:5,
  timeout:5000 )

ActiveRecord::Migration.create_table :colleges do |t|
  t.string :name
end

class College < ActiveRecord::Base
end
