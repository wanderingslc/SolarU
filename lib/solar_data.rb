module SolarData

  def initialize 
  end

  @api_key = ENV["SOLAR_U_API_KEY"]

  def self.get_energy_lifetime
    uri = URI("https://api.enphaseenergy.com/api/systems/242524/energy_lifetime")
    params = { :key => @api_key }
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    parsedResponse = JSON.parse(res.body)
    responseData = parsedResponse["production"]
    time = parsedResponse["start_date"]
    parsedTime = time.scan(/\d{4}-\d{2}-\d{2}/).first.to_datetime.to_i
    x = EnergyLifetimeArray.new
    x.raw_array = responseData
    x.parsed_array = responseData.each_with_index.map do |value, index|
      [ (index + parsedTime + (index * 86400)) * 1000, value ]
    end
    x.save
  end  
 
# ------------------------Monthly totals --------------------------
# run this on the second day of the month
  def self.get_monthly_production
    uri=URI("https://api.enphaseenergy.com/api/systems/242524/monthly_production")
    lastMonth = Time.now.beginning_of_month - 1.month
    timeStart = lastMonth.strftime("%Y-%m-%d")  
    params = { :key => @api_key, :start => "#{timeStart}" }  
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    parsedResponse = JSON.parse(res.body)
    resultFromCall = parsedResponse["production_wh"]
    monthlyData = MonthlyData.new
    monthlyData.powerProduced = resultFromCall
    monthlyData.forMonth = Time.now
    monthlyData.save
  end

  def self.retrieve_monthly_data
    months_count = MonthlyData.count
    months_count >= 12 ? months = MonthlyData.all[MonthlyData.count - 12..MonthlyData.count] : months = MonthlyData.all
    powerProducedArray = []
    MonthlyData.all.each do |x|
      powerProducedArray << x.powerProduced
    end
    starting_month = months[0].forMonth.beginning_of_month.to_i
    powerProducedArray.each_with_index.collect do |value, index|
      [ (starting_month + (index).months) * 1000, value]
      # in the above, you are also converting the time to javascript by multiplying by 1000
    end
  end




# ------------------------Weekly Production --------------------------
 def self.get_weekly_production
    uri=URI("https://api.enphaseenergy.com/api/systems/242524/power_week")
    params = { :key => @api_key}  
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    parsedResponse = JSON.parse(res.body)
    results = parsedResponse["production"]
    weeklyData = WeeklyData.new
    weeklyData.weeklyProduction = results.in_groups_of(288).map{|a| a.reduce(:+)}
    weeklyData.forWeek = Time.now
    weeklyData.save
  end

  def self.retrieve_weekly_data
    weeks_count = WeeklyData.count
    weeks_count >= 6 ? weeks = WeeklyData.all[WeeklyData.count - 6..WeeklyData.count] : weeks = WeeklyData.all
   
  end

# ------------------------Current Production --------------------------

# should be done once per day
  def self.get_current_production
    uri=URI("https://api.enphaseenergy.com/api/systems/242524/power_today")
    params = { :key => @api_key}  
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    parsedResponse = JSON.parse(res.body)
    results = parsedResponse["production"]
    dailyData = DailyProduction.new
    dailyData.production_totals = results
    dailyData.for_day = Time.now
    dailyData.save
  end

  def self.get_new_daily_values
    uri=URI("https://api.enphaseenergy.com/api/systems/242524/power_today")
    params = { :key => @api_key}  
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    parsedResponse = JSON.parse(res.body)
    results = parsedResponse["production"]
    difference = results.length - DailyProduction.last.production_totals.length
    # should it also update it?
    return results[-difference..results.length]
  end



end 


