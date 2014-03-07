class DailyProduction < ActiveRecord::Base
  serialize :power_array
  serialize :watts

  # attr_accessible :power_array, :start_time, :unix_time
end
