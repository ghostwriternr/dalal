require 'sidekiq/web'
Sidekiq::Web.set :sessions, false

Rails.application.routes.draw do
  resources :health, only: [:index]
  resources :templates, only: [:index]
  resources :channels, only: [:create, :show, :update, :delete] do
    member do
      put :generate_function
      put :execute_function
      post :webhook
      get :history
      get :stats
    end
  end
  resources :histories, only: [:show]

  mount Sidekiq::Web => '/sidekiq'
end
