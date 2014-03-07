class RequestsController < ApplicationController
  
  def current_watts
    @current_data = DailyProduction.last.power_array

    respond_to do |format|
      format.html {render :html => @current_data }
      format.json { render :json => @current_data }
    end
  end

  def current_watt_hours
    @current_watts = DailyProduction.last.watts
    respond_to do |format|
      format.html {render :html => @current_watts }
      format.json { render :json => @current_watts }
    end
  end


  def all_time
    @all_time_data = EnergyLifetimeArray.last.lifetime_data
    
    respond_to do |format|
      format.html {render :html => @all_time_data }
      format.json { render :json => @all_time_data }
    end  
  end
end
