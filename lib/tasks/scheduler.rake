require 'solar_data'
require 'weather_data'


# --------------------------  current  -----
desc "Get Current Data (Task 1)"
task :get_current_solar_data_one => :environment do
  puts "Getting most recent solar data (task one)"
  SolarData.get_current_production
  puts "done fetching current production (task 1)."
end

desc "Get Current Data (Task 2)"
task :get_current_solar_data_two => :environment do
  puts "Getting most recent solar data (task 2)"
  SolarData.get_current_production
  puts "done fetching current production (task 2)."
end

# --------------------------  weekly solar data  -----

desc "Get trailing seven day data"
task :get_last_seven_day_solar_data => :environment do
  puts "Getting solar data for the last seven days"
  SolarData.get_trailing_seven_days
  puts "done fetching seven-day solar data."
end
# --------------------------  current  -----
# --------------------------  current  -----
# --------------------------  current  -----
