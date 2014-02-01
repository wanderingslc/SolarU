module WeatherData
  require 'net/http'

  def self.get_weather_data
    cloud_container = []
    temperature_container = []

    7.times do |x|
      uri = URI("https://api.forecast.io/forecast/aac5a2bdc4552c42a0426514d27f107a/40.7650,-111.8500," + "#{(1390978800 - (x * 86400)).to_s}" + "?exclude=[minutely,hourly,daily,alerts,flags]")
      res = Net::HTTP.get_response(uri)
      parsedResponse = JSON.parse(res.body)
      cloud_container << parsedResponse["currently"]["cloudCover"]
      temperature_container << parsedResponse["currently"]["temperature"] 
    end
    
    x = WeatherRecord.new
    x.temperature = temperature_container
    x.cloud_cover = cloud_container
    x.date = Time.now.beginning_of_day - 1.day.to_i
    x.save
  end

  def self.get_temperature
  end

end
