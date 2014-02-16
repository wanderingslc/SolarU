module SolarData
  require 'net/http'
  def initialize 
  end  
  
  @api_key = ENV["SOLAR_U_API_KEY"]
  @api_name = ENV["SOLAR_U_API_URL"]

  def self.get_energy_lifetime
    uri = URI("#{@api_name}/energy_lifetime")
    params = { :key => @api_key }
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    parsedResponse = JSON.parse(res.body)
    responseData = parsedResponse["production"]
    unparsed_time = parsedResponse["start_date"]
    parsedTime = Time.parse(unparsed_time.scan(/\d{4}-\d{2}-\d{2}/).first)
    x = EnergyLifetimeArray.new
    x.lifetime_data = responseData
    x.unix_time = parsedTime.to_i
    x.save
  end  
 
# ------------- monthly graph ------------- ------------- ------------- 

# what about arrays that are not older than 1 month?
def self.split_current_data_into_months
  start_date = EnergyLifetimeArray.last.start_date
  first_month_days = start_date.end_of_month.day - start_date.day 
  start_date.end_of_month.day != start_date.day ? first_month_days = start_date.end_of_month.day - start_date.day : first_month_days = 1
  last_month = Time.now.beginning_of_month - 1.month

  x = MonthlyRecord.new
  x.month = start_date
  x.power_produced = EnergyLifetimeArray.last.lifetime_data.slice(0, first_month_days)
  x.save

  #array without that first partial month:
  culled_array = EnergyLifetimeArray.last.lifetime_data.slice(first_month_days, EnergyLifetimeArray.last.lifetime_data.length)

  #number of months that need populating, this excludes the first, partial month
  months_to_populate = (Time.now.year * 12 + Time.now.month) - (start_date.year * 12 + start_date.month)
  i = 0
  (months_to_populate - 1).times do |x|
    month = start_date + (x + 1).months
    if x == 0
     i = 0 
    end
    puts 'this is x: ' + x.to_s
    puts 'this is the first i: ' + i.to_s
    new_culled_array = culled_array.slice(i, month.end_of_month.day)
    y = MonthlyRecord.new
    y.month = month
    y.power_produced = new_culled_array
    y.save
    i = i + month.end_of_month.day
    puts i
  end
end


# ---------------------- Last 7 Days -------------------------------
def self.get_trailing_seven_days

    today = Time.now.beginning_of_day.strftime('%Y-%m-%d')
    minus_seven_days = (Time.now.beginning_of_day - 7.days).strftime('%Y-%m-%d')
    response_array = []
    7.times do |x|
        start_date = ((Time.now.beginning_of_day - 1.day) - x.days).strftime('%Y-%m-%d')
        end_date = (( Time.now.beginning_of_day ) - x.days).strftime('%Y-%m-%d')
        uri=URI(@api_name + '/stats?key=' + @api_key + '&start=' + start_date + 'T00:00-0700' +'&end=' + end_date + 'T00:00-0700')
        res = Net::HTTP.get_response(uri)
        parsedResponse = JSON.parse(res.body)
        parsedResponse['intervals'].each do |y|
            response_array << y['powr']
        end
    end

    x = LastSevenDaysArray.new
    x.power_array = response_array.in_groups_of(6).map{|a| a.reduce(:+)}
    x.start_date = Time.now.beginning_of_day - 7.days.to_i
    x.save
end

# ------------------------Current Production --------------------------

# should be done once per day
  # def self.get_current_production
  #   uri=URI("#{@api_name}/power_today")
  #   params = { :key => @api_key}  
  #   uri.query = URI.encode_www_form(params)
  #   res = Net::HTTP.get_response(uri)
  #   parsedResponse = JSON.parse(res.body)
  #   results = parsedResponse["production"]
  #   dailyData = DailyProduction.new
  #   dailyData.production_totals = results
  #   dailyData.for_day = Time.now
  #   dailyData.save
  # end

  def self.get_current_production
    uri=URI("#{@api_name}/stats")
    params = { :key => @api_key}  
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    parsedResponse = JSON.parse(res.body)
    time = parsedResponse["intervals"].first["end_date"]
    parsedTime = time.scan(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}-\d{2}:\d{2}/).first.to_datetime
    pow_array = []
    parsedResponse["intervals"].each do |pow|
      pow_array << pow["powr"]
    end
    dailyData = DailyProduction.new
    dailyData.power_array = pow_array
    dailyData.start_time = parsedTime
    dailyData.unix_time = parsedTime.to_i
    dailyData.save
  end

  # def self.get_new_daily_values
  #   uri=URI("#{@api_name}/stats")
  #   params = { :key => @api_key}  
  #   uri.query = URI.encode_www_form(params)
  #   res = Net::HTTP.get_response(uri)
  #   parsedResponse = JSON.parse(res.body)
  #   results = parsedResponse["production"]
  #   difference = results.length - DailyProduction.last.production_totals.length
  #   # should it also update it?
  #   return results[-difference..results.length]
  # end
end 


