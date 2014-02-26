class CurrentDataController < ApplicationController

  def show
    @current_data = DailyProduction.last.power_array

    respond_to do |format|
      format.html {render :html => @current_data }
      format.json { render :json => @current_data }
    end
  end

end
