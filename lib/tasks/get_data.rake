


desc 'Gets the daily production -- first'
task :current_one => :environment do
  Rails.logger.info "Running rake task current_one at #{Time.now}"
  puts "Getting the current production (first)!"
  SolarData.get_current_production
  DailyProduction.last.reload
  puts "Got all the Current production!"
end

desc 'gets the daily production -- second'
task :current_two => :environment do
  Rails.logger.info "Running rake task current_two at #{Time.now}"
  puts "Getting the current production (second)!"
  SolarData.get_current_production
  DailyProduction.last.reload
  puts "Got all the Current production!"
end

# daily tasks --------------------------------------------------

desc 'This gets all the data'
task :once_a_day => [:lifetime, :seven_days, :weather] do
  Rails.logger.info "Running rake task once_a_day at #{Time.now}"
  puts "All Done!"
end

desc 'Gets the lifetime energy'
task :lifetime => :environment do
  Rails.logger.info "Running rake task lifetime at #{Time.now}"
  puts "Getting the lifetime energy!"
  SolarData.get_energy_lifetime
  puts "Got All the lifetime energy!"
end

desc 'Gets the last 7 days'
task :seven_days => :environment do
  Rails.logger.info "Running rake task seven_days at #{Time.now}"
  puts "Getting the last seven days!"
  SolarData.get_trailing_seven_days
  puts "Got the last seven days!"
end

desc 'Gets all the weather data'
task :weather => :environment do
  Rails.logger.info "Running rake task weather at #{Time.now}"
  puts "Getting the weather!"
  WeatherData.get_weather_data
  puts "Got all the weather!"
end