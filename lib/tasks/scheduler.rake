desc "Get Gurrent Data"
task :get_current_solar_data => :environment do
  puts "Getting most recent solar data"
  SolarData.get_current_production
  puts "done fetching current production."
end
