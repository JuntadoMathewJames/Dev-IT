Rails.application.routes.draw do
  #PRODUCTS
  resources :products
  post "/products/add",to:"products#new"
  post "/products/:id/edit",to:"products#edit"
  post "/products/search",to:"products#search"

  #GENERAL FEATURES
  get "/login", to: "users#index"
  get "/logout", to:"users#logout"
  get "/account_details/:method",to:"general_features#account_details"
  get "/dashboard",to:"general_features#index"
  get "/pos",to:"sales#index"
  post "/register/proceed",to:"users#register_proceed"
  post "/login/proceed",to:"users#login_proceed"
  post "/subscribe/proceed", to:"users#subscribe_proceed"
  post "/cancel_subscription", to:"users#cancel_subscription"
  post "/renew_subscription",to:"users#renew_subscription"
  post "/change_password",to:"users#change_password"
  post "/change_password/proceed",to:"users#change_password_proceed"

  #TRANSACTIONS
  get "/transactions",to:"transactions#index"
  get "/transactions/new",to:"transactions#new"
  get "/transactions/:id/view",to:"transactions#view"
  post "/transactions/search",to:"transactions#search"
  post "/transactions/order/save", to:"transactions#save_order"
  post "/transactions/order/:id/delete",to:"transactions#delete"
  post "/transactions/payment",to: "transactions#payment"
  post "/transactions/save",to:"transactions#create"
  delete "/transactions/:id/destroy",to:"transactions#destroy"


  #SALES
  get "/sales",to:"sales#index"
  get "/sales/new",to:"sales#new"
  get "/sales/:id/add_expenses",to:"sales#expense_form"
  get "/sales/:id/view",to:"sales#view"

  post "/sales/search",to:"sales#search"
  post "/sales/proceed",to:"sales#proceed"
  post "/sales/:id/expenses/save",to:"sales#save_expense"
  post "/sales/generate",to:"sales#generate_sale"
  delete "/sales/:id/destroy",to:"sales#destroy"
  delete "/sales/expense/:sale_id/:id/destroy",to:"sales#destroy_expense"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "users#index"
end
