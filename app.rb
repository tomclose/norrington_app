require 'sinatra'
require 'csv'
load './db.rb'

connect_to_db

data = CSV.read('./data/norrington_over_years.csv', :col_sep => "\t")

headings = data.first
values = data[1..-1]

values_as_hashes = values.map {|v| Hash[headings.zip(v)] }

get '/' do
  @name = 'tom'
  erb :index
end

get '/year/:year' do | year |
  if Year.find_by_name(year)
    y = Year.find_by_name(year)
    @data = y.data_points.map do |dp|
      [dp.college.name, dp.college.college_type.name, dp.score]
    end
    @year = year
    erb :year_ranking

  else
    @year = year
    erb :missing_year
  end
end

get '/college/new' do 
  erb :new_college
end

post '/college/new' do 
  raise params.inspect
  erb :new_college
end
