class HomeController < ApplicationController
  
  # before_filter :check_data, :only => [:index]

  def index
    # @energyLifetimeData = EnergyLifetimeArray.last.lifetime_data
    # @energySavedAllTime = ((EnergyLifetimeArray.last.lifetime_data.reduce(:+) / 1000) * 8.69) / 100
    # @energySavedYesterday = ((EnergyLifetimeArray.last.lifetime_data.pop / 1000) * 8.69) / 100
    # the above figure comes from http://www.eia.gov/state/print.cfm?sid=UT
    # @energyMonthlyData = SolarData.retrieve_monthly_data
    # @energyWeeklyData = SolarData.retrieve_weekly_data
    # @totalOutput = EnergyLifetimeArray.last.raw_array.reduce(:+)
    # @averageOutput = (@totalOutput / (EnergyLifetimeArray.last.raw_array.count))
    # @highestOutput = EnergyLifetimeArray.last.raw_array.max
    
    # lifetime -----------------------------------------------------------------------------
    gon.lifetime_unix_time = EnergyLifetimeArray.last.unix_time * 1000
    gon.lifetime_data = EnergyLifetimeArray.last.lifetime_data

    # daily   -----------------------------------------------------------------------------
    # gon.watch.daily_unix_time = DailyProduction.last.unix_time * 1000
    # gon.watch.daily_data = DailyProduction.last.power_array
    @daily_data = DailyProduction.last.power_array
    @daily_time = DailyProduction.last.unix_time * 1000

    # money saved -----------------------------------------------------------------------------
    @total_output = EnergyLifetimeArray.last.lifetime_data.reduce(:+)

    # last seven days -----------------------------------------------------------------------------
    gon.last_seven_day_time = (Time.now.beginning_of_day - 7.days).to_i * 1000
    gon.last_seven_day_data = LastSevenDaysArray.last.power_array

    gon.temperature_time = (Time.now.beginning_of_day - 7.days).to_i * 1000
    # temperature for the last seven days
    temperature_container = []
    WeatherRecord.order('id desc').limit(7).each do |x|
      temperature_container << x.temperature 
    end
    gon.temperature_data = temperature_container.reverse!.flatten

    gon.cloud_cover_time = (Time.now.beginning_of_day - 7.days).to_i * 1000
    # cloud cover for the last seven days
    cloud_container = []
    WeatherRecord.order('id desc').limit(7).each do |x|
      cloud_container << x.cloud_cover
    end
    gon.cloud_cover_data = cloud_container.reverse!.flatten

    # last three months -----------------------------------------------------------------------------

    3.times do |x|
      if x == 0
        gon.monthly_name_one = (Time.now.beginning_of_month - 3.months).strftime("%B") 
        gon.monthly_data_one = SolarData.slice_lifetime_into_month(Time.now.beginning_of_month - 3.months)
      elsif x == 1
        gon.monthly_name_two = (Time.now.beginning_of_month - 2.months).strftime("%B") 
        gon.monthly_data_two = SolarData.slice_lifetime_into_month(Time.now.beginning_of_month - 2.months)
      else
        gon.monthly_name_three = (Time.now.beginning_of_month - 1.months).strftime("%B")   
        gon.monthly_data_three = SolarData.slice_lifetime_into_month(Time.now.beginning_of_month - 1.months)
      end
    end

  end
 
  private
  def check_data # if database is empty or old, get data
    # SolarData.get_energy_lifetime if EnergyLifetimeArray.nil? || EnergyLifetimeArray.last.updated_at < (Time.now - 1.day)
    # SolarData.get_trailing_seven_days if LastSevenDaysArray.nil? || LastSevenDaysArray.last.updated_at < (Time.now - 3.day)
    # WeatherData.get_weather_data if WeatherRecord.nil? || WeatherRecord.last.updated_at < (Time.now - 3.day)
    # SolarData.get_monthly_production if MonthlyData.last.nil?
    # SolarData.get_weekly_production if WeeklyData.last.nil?
    # SolarData.get_current_production if DailyProduction.nil? || DailyProduction.last.updated_at < (Time.now - 1.day)
  end

end
