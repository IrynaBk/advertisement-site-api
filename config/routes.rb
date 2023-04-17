Rails.application.routes.draw do
  resources :advertisements
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post '/login', to: 'authentication#login'
  # Defines the root path route ("/")
  # root "articles#index"
end
