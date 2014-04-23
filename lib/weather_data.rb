module WeatherData
  require 'net/http'

  def self.get_weather_data
     
    if WeatherRecord.any? == false | days_to_populate > 7
      days_to_populate = 7
    else 
      last_record_time = Time.at(WeatherRecord.last.date)
      days_to_populate = (Time.now - 1.day).yday - last_record_time.yday
    end

    starting_day = Time.now.beginning_of_day - days_to_populate.days

    days_to_populate.times do |by_the_day|
      cloud_container = []
      temperature_container = []
      failure_iterator = 0
      success = 0
      48.times do |x|
        uri = URI("https://api.forecast.io/forecast/" + ENV['WEATHER_API_KEY'] + "/40.7650,-111.838915," + ((starting_day).to_i + (x * 1800)).to_s + "?exclude=[minutely,hourly,daily,alerts,flags]")
        begin
          res = Net::HTTP.get_response(uri)
        rescue JSON::ParserError => e
          failure_iterator += 1
          Rails.logger.error "JSON Error populating weather"
          if failure_iterator > 50
            retry
          else
            Rails.logger.error "[Weather] Failure limit reached at #{Time.now}"
          end
        rescue Net::ReadTimeout => e
          failure_iterator += 1
          Rails.logger.error "[weather data] Error Read Timeout! Retrying!"
          if failure_iterator > 50
            retry
          else
            Rails.logger.error "[Weather] Failure limit reached at #{Time.now}"
          end
        rescue => e
          failure_iterator += 1
          Rails.logger.error "Unknown error populating weather"
          if failure_iterator > 50
            retry
          else
            Rails.logger.error "[Weather] Failure limit reached at #{Time.now}"
          end
        end
        if res.code == '200'
          parsedResponse = JSON.parse(res.body)        
          cloud_container << parsedResponse["currently"]["cloudCover"]
          temperature_container << parsedResponse["currently"]["temperature"] 
          puts "call  #{x + 1} of 48 for day #{by_the_day + 1} of #{ days_to_populate }"
          puts uri
          puts Time.at((starting_day).to_i + (x * 1800))
          success += 1
        end
      end
      if success == days_to_populate
        x = WeatherRecord.new
        x.temperature = temperature_container
        x.cloud_cover = cloud_container
        x.date = starting_day.to_i
        x.save
        starting_day += 1.day
        puts "Starting day: #{starting_day}"
        success = 0
      end
    end
  end
end
