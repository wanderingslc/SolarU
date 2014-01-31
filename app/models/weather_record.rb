class WeatherRecord < ActiveRecord::Base
  # attr_accessible :title, :body
  serialize :cloud_cover
  serialize :temperature
end
