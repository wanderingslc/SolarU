class DailyProduction < ActiveRecord::Base
  attr_accessible :power_array, :start_time, :unix_time
end
