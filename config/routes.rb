Rails.application.routes.draw do
  resources :customers, only: [:index, :show]
  resources :videos, only: [:index, :show]
  resources :rentals, only: [:index, :show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
