Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :channels, only: [:create, :show, :update, :delete] do
    member do
      put :generate_function
      put :execute_function
      post :webhook
    end
  end
  resources :histories, only: [:show, :create]
end
