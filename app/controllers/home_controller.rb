
class HomeController < ApplicationController
  
  # before_filter :check_data, :only => [:index]

  def index
    # stats variables --------------------------------------------------------------------------------------
    @total_output = EnergyLifetimeArray.last.lifetime_data.reduce(:+)
    @averageOutput = ((EnergyLifetimeArray.last.lifetime_data.reduce(:+)) / (EnergyLifetimeArray.last.lifetime_data.count))
    @highestOutput = EnergyLifetimeArray.last.lifetime_data.max
    @peak_time = (DailyProduction.last.power_array.each_with_index.max_by { |x, idx| x || -1 }[1])


    # lifetime --------------------------------------------------------------------------------------
    @lifetime_unix_time = EnergyLifetimeArray.last.unix_time * 1000
    @lifetime_data = EnergyLifetimeArray.last.lifetime_data

    # daily   --------------------------------------------------------------------------------------
    @daily_data = DailyProduction.last.power_array
    @daily_time = DailyProduction.last.unix_time * 1000

    # last seven days --------------------------------------------------------------------------------
    @last_seven_day_time = (Time.now.beginning_of_day - 7.days).to_i * 1000
     @last_seven_day_data = LastSevenDaysArray.last.power_array

    # temperature -----------------------------------------------------------------------------------
    temperature_container = []
    WeatherRecord.order('id desc').limit(7).each do |x|
      temperature_container << x.temperature 
    end
    @temperature_data = temperature_container.reverse!.flatten

    # cloud cover ----------------------------------------------------------------------------------- 
    cloud_container = []
    WeatherRecord.order('id desc').limit(7).each do |x|
      cloud_container << x.cloud_cover
    end
    @cloud_cover_data = cloud_container.reverse!.flatten

    # comparisons-------------------------------------------------------------------------------------
    @comparison_money = (((@total_output / 1000) * 7.74) / 100).round(2)
    @comparison_trees = (@total_output / 55300).round(2)
    @comparison_coffee = (@total_output / 80).round(2)
    @comparison_laptops = (@total_output / 55).round(2)
    @comparison_houses = (@total_output / 10837000).round(2)
    @comparison_coal = (@total_output / 900).round(2)
    @comparison_natural_gas = (@total_output / 127).round(2)

    # last three months -----------------------------------------------------------------------------

    3.times do |x|
      if x == 0
        @monthly_name_one = (Time.now.beginning_of_month - 3.months).strftime("%B") 
        @monthly_data_one = SolarData.slice_lifetime_into_month(Time.now.beginning_of_month - 3.months)
      elsif x == 1
        @monthly_name_two = (Time.now.beginning_of_month - 2.months).strftime("%B") 
        @monthly_data_two = SolarData.slice_lifetime_into_month(Time.now.beginning_of_month - 2.months)
      else
        @monthly_name_three = (Time.now.beginning_of_month - 1.months).strftime("%B")   
        @monthly_data_three = SolarData.slice_lifetime_into_month(Time.now.beginning_of_month - 1.months)
      end
    end
  end
  private
  def check_data # if database is empty or old, get data
    SolarData.get_energy_lifetime if EnergyLifetimeArray.nil? || EnergyLifetimeArray.last.updated_at < (Time.now - 1.day)
    SolarData.get_trailing_seven_days if LastSevenDaysArray.nil? || LastSevenDaysArray.last.updated_at < (Time.now - 3.day)
    WeatherData.get_weather_data if WeatherRecord.nil? || WeatherRecord.last.updated_at < (Time.now - 3.day)
    SolarData.get_monthly_production if MonthlyData.last.nil?
    SolarData.get_weekly_production if WeeklyData.last.nil?
    SolarData.get_current_production if DailyProduction.nil? || DailyProduction.last.updated_at < (Time.now - 1.day)
  end

end
