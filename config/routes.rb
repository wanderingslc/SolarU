SolarU::Application.routes.draw do
  get "requests/current_watts"
  get "requests/current_watt_hours"
  get "requests/all_time"
  root :to => "home#index" 
end
