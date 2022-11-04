Rails.application.routes.draw do
  resources :products

  get "/login", to: "users#index"
  get "/logout", to:"users#logout"
  get "/account_details/:method",to:"general_features#account_details"
  get "/dashboard",to:"general_features#index"
  get "/pos",to:"general_features#pos"

  post "/register/proceed",to:"users#register_proceed"
  post "/login/proceed",to:"users#login_proceed"
  post "/subscribe/proceed", to:"users#subscribe_proceed"
  post "/cancel_subscription", to:"users#cancel_subscription"
  post "/renew_subscription",to:"users#renew_subscription"
  post "/change_password",to:"users#change_password"
  post "/change_password/proceed",to:"users#change_password_proceed"

  post "/products/add",to:"products#new"
  post "/products/:id/edit",to:"products#edit"
  post "/products/search",to:"products#search"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "users#index"
end
