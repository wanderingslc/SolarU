class MonthlyRecord < ActiveRecord::Base
  # attr_accessible :title, :body
  serialize :power_produced
end
