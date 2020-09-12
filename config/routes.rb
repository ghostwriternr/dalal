Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :channels, only: [:create, :show, :update, :delete]
  resources :histories, only: [:show, :create]
end
