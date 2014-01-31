# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :daily_production do
    power_array "MyText"
    start_time "2014-01-30 17:19:34"
    unix_time 1
  end
end
