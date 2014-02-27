SolarU::Application.routes.draw do
  get "requests/current"
  root :to => "home#index" 
end
