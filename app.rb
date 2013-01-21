require 'sinatra'
require 'csv'

data = CSV.read('./data/norrington_over_years.csv', :col_sep => "\t")

headings = data.first
values = data[1..-1]

values_as_hashes = values.map {|v| Hash[headings.zip(v)] }

get '/' do
  @name = 'tom'
  erb :index
end

get '/year/:year' do | year |
   allowed_years = %w( 2006 2007 2008 2009 2010 2011 2012)
   if allowed_years.include?(year)
     score_column_name = "#{year} Score"
     @data = values_as_hashes.map do |h|
       [h['Name'], h['Type'], h[score_column_name]]
     end
     @data.reject! {|h| h[2].nil?}
     @data.sort_by! {|h| h[2] }.reverse!
     @year = year
     erb :year_ranking

   else
     @year = year
     erb :missing_year
   end
end
