load './db.rb'

connect_to_db

# refresh all data
destroy_data
load_data

c = College.find_by_name('Oriel')
c.data_points


