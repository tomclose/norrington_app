require 'rubygems'
require 'active_record'
require 'csv'

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "data/database.sqlite3",
  pool:5,
  timeout:5000 )

ActiveRecord::Migration.create_table :colleges do |t|
  t.string :name
  t.integer :college_type_id
end

ActiveRecord::Migration.create_table :college_types do |t|
  t.string :name
end

ActiveRecord::Migration.create_table :years do |t|
  t.string :name
end

ActiveRecord::Migration.create_table :data_points do |t|
  t.integer :college_id
  t.integer :year_id
  t.decimal :score
  t.integer :count
end

class CollegeType < ActiveRecord::Base
  has_many :colleges
end

class College < ActiveRecord::Base
  belongs_to :college_type
  has_many :data_points
end

class Year < ActiveRecord::Base
  has_many :data_points
end

class DataPoint < ActiveRecord::Base
  belongs_to :college
  belongs_to :year
end

data = CSV.read('./data/norrington_over_years.csv', :col_sep => "\t",:encoding => 'UTF-8')

headings = data.first
values = data[1..-1]

values_as_hashes = values.map {|v| Hash[headings.zip(v)] }

allowed_years = %w( 2006 2007 2008 2009 2010 2011 2012)

allowed_years.each do |year|
  Year.create(:name => year)
end

values_as_hashes.each do |hash|
  t = CollegeType.find_or_create_by_name(hash['Type'])
  college_name = hash['Name']
  if c = College.find_by_name(college_name)
    # do nothing
  else
    c = College.create(:name => hash['Name'], :college_type => t)
  end
  allowed_years.each do |year|
    score = hash["#{year} Score"]
    count = hash["#{year} Count"]
    y = Year.find_by_name(year)
    if score && count
      DataPoint.create(:college => c, :year => y, :score => score, :count => count)
    end
  end
end

