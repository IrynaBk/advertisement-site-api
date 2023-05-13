Rails.application.routes.draw do
  resources :chat_rooms, only: [:create, :index, :show] do
    resources :messages, only: [:create, :index]
  end
  post '/reset_password', to: 'password_reset#create'
  put '/reset_password/:token', to: 'password_reset#update', as: :update_password_reset  
  mount ActionCable.server => "/cable"
  resources :advertisements
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post '/login', to: 'authentication#login'
  delete '/logout', to: 'authentication#logout'

  # Defines the root path route ("/")
  # root "articles#index"
end
