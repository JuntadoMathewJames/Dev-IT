Rails.application.routes.draw do
  resources :products

  get "/login", to: "users#index"
  get "/logout", to:"users#logout"
  get "/subscribe",to:"users#subscribe"
  get "/dashboard",to:"general_features#index"
  get "/pos",to:"general_features#pos"
  get "/account_details",to:"general_features#account_details"

  post "/register/proceed",to:"users#register_proceed"
  post "/login/proceed",to:"users#login_proceed"
  post "/subscribe/proceed", to:"users#subscribe_proceed"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "users#index"
end
