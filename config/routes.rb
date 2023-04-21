Rails.application.routes.draw do
  mount ActionCable.server => "/cable"

  resources :advertisements
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post '/login', to: 'authentication#login'
  delete '/logout', to: 'authentication#logout'

  # Defines the root path route ("/")
  # root "articles#index"
end
