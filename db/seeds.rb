puts "Populating the database\n"
puts "Getting Current production"
SolarData.get_current_production
puts "Getting lifetime Energy"
SolarData.get_energy_lifetime
puts "Current Month Data"
SolarData.split_current_data_into_months
puts "Getting the last 7 days"
SolarData.get_trailing_seven_days
puts "Getting the weekly data"
SolarData.get_weekly_production
puts "Getting the weather data..."
puts "This might take a while..."
WeatherData.get_weather_data