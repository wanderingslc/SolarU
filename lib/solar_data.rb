module SolarData 
  require 'net/http'

  @api_key = ENV["SOLAR_U_API_KEY"] 
  @api_name = ENV["SOLAR_U_API_URL"]

  def self.get_energy_lifetime
    # watt hours
    uri = URI("#{@api_name}/energy_lifetime")
    params = { :key => @api_key }
    uri.query = URI.encode_www_form(params)
    try_iterator = 0
    begin
      res = Net::HTTP.get_response(uri)
    rescue JSON::ParserError => e
      Rails.logger.error "[get_energy_lifetime]JSON Error at #{Time.now}"
      try_iterator += 1
      if try_iterator >= 50
        retry
      end
    rescue Net::ReadTimeout => e
      Rails.logger.error "[get_energy_lifetime] Read Timeout Error at #{Time.now}"
      try_iterator += 1
      if try_iterator >= 50
        retry
      end
    rescue => e
      Rails.logger.error "[get_energy_lifetime] Error at #{Time.now}"
      try_iterator += 1
      if try_iterator >= 50
        retry
      end
    end
    if res.code == '200'
      parsedResponse = JSON.parse(res.body)    
      responseData = parsedResponse["production"]
      unparsed_time = parsedResponse["start_date"]
      parsedTime = Time.parse(unparsed_time.scan(/\d{4}-\d{2}-\d{2}/).first)
      if EnergyLifetimeArray.count == 0
        x = EnergyLifetimeArray.new 
      else
        x = EnergyLifetimeArray.last
      end
      x.lifetime_data = responseData
      x.unix_time = parsedTime.to_i
      x.save
    else
      Rails.logger.error "Error getting energy lifetime at #{Time.now}"
    end
  end  
 
# ------------- monthly graph ------------- ------------- ------------- 

  def self.slice_lifetime_into_month(month_to_slice)
    # watt hours (comes from energy lifetime)
    start_day = Time.at(EnergyLifetimeArray.last.unix_time)
    puts "Start day: #{start_day}"
    days_before_month = ((month_to_slice - start_day) / 86400).round
    puts "Days before month: #{days_before_month}"
    days_in_month = month_to_slice.end_of_month.day
    puts "Days in Month: #{days_in_month}"
    return EnergyLifetimeArray.last.lifetime_data.slice((days_before_month), (days_in_month))
  end


# ---------------------- Last 7 Days -------------------------------
  def self.get_trailing_seven_days
    # can be in watts or watt-hours but watts are significantly lower and may be confusing if you 
    # compare them to the all_time graph
    today = Time.now.beginning_of_day.strftime('%Y-%m-%d')
    minus_seven_days = (Time.now.beginning_of_day - 7.days).strftime('%Y-%m-%d')
    response_array = []
    7.times do |x|
      start_date = ((Time.now.beginning_of_day - 1.day) - x.days).strftime('%Y-%m-%d')
      end_date = (( Time.now.beginning_of_day ) - x.days).strftime('%Y-%m-%d')
      uri=URI(@api_name + '/stats?key=' + @api_key + '&start=' + start_date + 'T00:00-0700' +'&end=' + end_date + 'T00:00-0700')
      try_iterator = 0        
      begin
        res = Net::HTTP.get_response(uri)
      rescue JSON::ParserError => e
        Rails.logger.info "#{e}"
        try_iterator += 1
        if try_iterator <= 50
          retry
        else
          Rails.logger.error "[get_trailing_seven_days] JSON error at #{Time.now}"
        end
      rescue Net::ReadTimeout => e
        Rails.logger.info "#{e}"
        if try_iterator <= 50
          retry
        else
          Rails.logger.error "[get_trailing_seven_days] READTIMEOUT error at #{Time.now}"
        end
      rescue => e
        Rails.logger.info "#{e}"
        if try_iterator <= 50
          retry
        else
          Rails.logger.error "[get_trailing_seven_days] other error at #{Time.now}"  
        end      
      end
      if res.code == '200'
        parsedResponse = JSON.parse(res.body)
        parsedResponse['intervals'].each do |y|
          response_array << y['enwh']
        end
        x = LastSevenDaysArray.new
        x.power_array = response_array.in_groups_of(6).map{|a| a.reduce(:+)}
        x.start_date = Time.now.beginning_of_day - 7.days.to_i
        x.save        
      else
        Rails.logger.error "error running seven_days at #{Time.now}"
      end
    end
  end

# ------------------------Current Production --------------------------

  def self.get_current_production
    # can be in either watts or wh, currently storing both
    10.times do 
      uri=URI("#{@api_name}/stats")
      params = { :key => @api_key}  
      uri.query = URI.encode_www_form(params)
      begin
        res = Net::HTTP.get_response(uri)  
      rescue JSON::ParserError => e
        sleep 5
        puts e.message
        Rails.logger.error "[get_current_production], #{e.message} at #{Time.now}"
        puts "Error JSON Error! Retrying!"
        retry
      rescue Net::ReadTimeout => e
        sleep 5
        Rails.logger.error "[get_current_production], #{e.message} at #{Time.now}"
        puts "Error Read Timeout! Retrying!"
        retry
      rescue Net::HTTPServiceUnavailable => e
        sleep 10
        Rails.logger.error "[get_current_production], #{e.message} at #{Time.now}"
        retry
      rescue => e
        sleep 5
        Rails.logger.error "[get_current_production], #{e.message} at #{Time.now}"
        retry
      end
      if res.code == '200'
        puts uri
        parsedResponse = JSON.parse(res.body)
        time = parsedResponse["intervals"].first["end_date"]
        parsedTime = time.scan(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}-\d{2}:\d{2}/).first.to_datetime
        pow_array = []
        watt_array = []
        parsedResponse["intervals"].each do |pow|
          pow_array << pow["powr"]
          watt_array << pow["enwh"]
        end

        if DailyProduction.count == 0
          dailyData = DailyProduction.new 
        else
          dailyData = DailyProduction.last
        end
        dailyData.watts = watt_array
        dailyData.power_array = pow_array
        dailyData.start_time = parsedTime
        dailyData.unix_time = parsedTime.to_i
        dailyData.save
        break
      else
        Rails.logger.error "Unhandled failure for SolarData.get_current_production at #{Time.now}, #{res.body}"
      end
    end
  end
end 


