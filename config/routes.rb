Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :customers, only: [:index, :show, :create]
  resources :videos, only: [:index, :show, :create]
end
