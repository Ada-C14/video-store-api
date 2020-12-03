Rails.application.routes.draw do
  resources :customers, only: [:index, :show]
  resources :videos, only: [:index, :show, :create]
  # resources :rentals, only: [:index, :show]
  post '/rentals/checkout', to: "rentals#checkout", as: 'checkout'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
