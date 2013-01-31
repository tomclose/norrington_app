require 'rubygems'
require 'active_record'
require 'csv'

# read in the data from the CSV file
# this should return an array of arrays - try it out
# in the console
data = CSV.read('./data/norrington_over_years.csv', :col_sep => "\t", :encoding => 'UTF-8')

# This tells ActiveRecord which database to connect to
# and that it should connect now
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "data/database.sqlite3",
  pool:5,
  timeout:5000 )

# Create the college table.
# *** If the table already exists it will complain ***
ActiveRecord::Migration.create_table :colleges do |t|
  t.string :name
end


# This is the college class. By inheriting from 
# ActiveRecord::Base it will magically have the right 
# methods to map onto the rows of the database
class College < ActiveRecord::Base
end


# Things to try:

c = College.new
# Create new college. Not in the database yet. (Check in SqliteManager).
# In programming terms you're creating an 'instance' of
# the College class

c.name = "Oriel"
# Set the college's name using the name= method, it has
# magically given itself by looking at the database col names
# name= is an 'instance method' - you call it on the instance

c.save
# Should now be in the database. (Check in SqliteManager).

c.id
# c should now have an 'id'. Take a note of it.

College.all
# Should provide an array of college objects currently in
# the db
# all is a 'class method' - you call it directly on the class

College.count
# another class method what does it do?

College.destroy_all
# delete all colleges

c = College.create(:name => 'Oriel')
# a quicker way of creating a college
# equivalent to doing College.new(:name => 'Oriel')
#   followed by a save
# Note how the database will have given this one 
# a different id to the one you created first time round

c2 = College.find(:name => 'Oriel')
# should return the college you just created
# you might see some sql in the terminal - 
#    this is the language ruby uses to communicate
#    with the database. Does it make sense?

c2.destroy
# a way of destroying a single database object

College.all
# should return an empty array

# TODO - Your homework is to write a piece of code
# that takes each college name from the data array
# and puts it into the database

# WRITE YOUR CODE HERE


# When you're done

College.count #=> 38
