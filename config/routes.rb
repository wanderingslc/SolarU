SolarU::Application.routes.draw do
  resource :current_data
  root :to => "home#index" 
end
