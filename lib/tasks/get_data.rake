desc 'Gets the lifetime energy'
task :lifetime => :environment do
  puts "Getting the lifetime energy!"
  SolarData.get_energy_lifetime
  puts "Got All the lifetime energy!"
end

desc 'Gets the last 7 days'
task :seven_days => :environment do
  puts "Getting the last seven days!"
  SolarData.get_trailing_seven_days
  puts "Got the last seven days!"
end

desc 'Gets the daily production'
task :current => :environment do
  puts "Getting the current production!"
  SolarData.get_current_production
  DailyProduction.last.reload
  puts "Got all the Current production!"
end

desc 'Gets all the weather data'
task :weather => :environment do
  puts "Getting the weather!"
  WeatherData.get_weather_data
  puts "Got all the weather!"
end

desc 'This gets all the data'
task :once_a_day => [:lifetime, :seven_days, :weather] do
  puts "All Done!"
end