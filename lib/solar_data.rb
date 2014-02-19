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

def self.split_current_data_into_months
  # only for systems with at least one month of complete data
  unless EnergyLifetimeArray.last.lifetime_data.count <= Time.at(EnergyLifetimeArray.last.unix_time).end_of_month.day 
    start_date = Time.at(EnergyLifetimeArray.last.unix_time)
    
    # number of days in first month  
    start_date.end_of_month.day != start_date.day ? days_in_first_month = (start_date.end_of_month.day - start_date.day) + 1 : days_in_first_month = 1
    
    last_month = Time.now.beginning_of_month - 1.month

    # save the first month's data
    x = MonthlyRecord.new
    x.month = start_date
    x.power_produced = EnergyLifetimeArray.last.lifetime_data.slice(0, days_in_first_month)
    x.save

    #array without that first partial month:
    culled_array = EnergyLifetimeArray.last.lifetime_data.slice(days_in_first_month, EnergyLifetimeArray.last.lifetime_data.length)

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
end

def self.slice_lifetime_into_month(month_to_slice)
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


