module WeatherData
  require 'net/http'

  # run once to seed the database
  def self.get_weather_data
     
    unless WeatherRecord.any?
      days_to_populate = 7
    else 
      last_record_time = Time.at(WeatherRecord.last.date)
      days_to_populate = Time.now.yday - last_record_time.yday
    end
    if days_to_populate > 7 
      days_to_populate = 7
    end

    starting_day = Time.now.beginning_of_day - days_to_populate.days

    days_to_populate.times do |by_the_day|
      cloud_container = []
      temperature_container = []

      48.times do |x|
        uri = URI("https://api.forecast.io/forecast/" + ENV['WEATHER_API_KEY'] + "/40.7650,-111.838915," + ((starting_day).to_i + (x * 1800)).to_s + "?exclude=[minutely,hourly,daily,alerts,flags]")
        res = Net::HTTP.get_response(uri)
        parsedResponse = JSON.parse(res.body)
        cloud_container << parsedResponse["currently"]["cloudCover"]
        temperature_container << parsedResponse["currently"]["temperature"] 
        puts "call  #{x + 1} of 48 for day #{by_the_day + 1} of #{ days_to_populate }"
        puts uri
        puts Time.at((starting_day).to_i + (x * 1800))
      end

      x = WeatherRecord.new
      x.temperature = temperature_container
      x.cloud_cover = cloud_container
      x.date = starting_day.to_i
      x.save
      starting_day += 1.day
      puts "Starting day: #{starting_day}"

    end
    

  end

end
