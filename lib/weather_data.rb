module WeatherData
  require 'net/http'



  def self.get_weather_data
    cloud_container = []
    temperature_container = []

    10.times do |x|
      uri = URI("https://api.forecast.io/forecast/aac5a2bdc4552c42a0426514d27f107a/40.7650,-111.8500," + "#{(1390978800 - (x * 3600)).to_s}" + "?exclude=[minutely,hourly,daily,alerts,flags]")
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




  def self.get_last_seven_energy
    7.times do
      uri = URI("https://api.enphaseenergy.com/api/systems/242524/stats")
      params = { 
                  :key => '40de436ba96bef946401fcf18a66f021',
                  :start => '2014-01-22T00:00-0700',
                  :end => '2014-01-29T00:00-0700'  #this is the beginning of the day on the 29th
      }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      parsedResponse = JSON.parse(res.body)
      production_array = []
      parsedResponse["intervals"].each do |y|
        production_array << y["powr"]
    end

    end
  end

  # def self.get_weather_data
  #   168.times do |x|
  #     uri = URI("https://api.forecast.io/forecast/aac5a2bdc4552c42a0426514d27f107a/40.7650,-111.8500," + "#{(1390978800 - (x * 3600)).to_s}" + "?exclude=[minutely,hourly,daily,alerts,flags]")
  #     res = Net::HTTP.get_response(uri)
  #     parsedResponse = JSON.parse(res.body)
  #     weather_output_array = []
  #     weather_output_array << parsedResponse["currently"]["cloudCover"]
  #     puts weather_output_array
  #   end
  # end


  def self.test_fetch
      uri = URI("https://api.forecast.io/forecast/aac5a2bdc4552c42a0426514d27f107a/40.7650,-111.8500,1390790589?exclude=[minutely,hourly,daily,alerts,flags]")
      res = Net::HTTP.get_response(uri)
      parsedResponse = JSON.parse(res.body)
      x = WeatherRecord.new
      puts parsedResponse
      x.temperature = parsedResponse["currently"]["temperature"]
      x.cloud_cover = parsedResponse["currently"]["cloudCover"]
      x.date = parsedResponse["currently"]["time"]
      x.save
  end

  def self.populate_a_test_array
    output_container = []
    288.times do |x|
      uri = URI("https://api.forecast.io/forecast/aac5a2bdc4552c42a0426514d27f107a/40.7650,-111.8500," + "#{(1390978800 - (x * 300)).to_s}" + "?exclude=[minutely,hourly,daily,alerts,flags]")
      res = Net::HTTP.get_response(uri)
      parsedResponse = JSON.parse(res.body)
      output_container << parsedResponse["currently"]["cloudCover"] 
      puts parsedResponse
      puts output_container
    end
    fname = "second_attempt.txt"
    somefile = File.open("second_attempt.txt", "w")
    somefile.puts output_container
    somefile.close 
  end



end
