Rails.application.routes.draw do
  # resources :transactions
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/balances', to: 'transactions#index'
  post '/add_transaction', to: 'transactions#create_transactions'
  post '/spend_points', to: 'transactions#spend_points'
end
