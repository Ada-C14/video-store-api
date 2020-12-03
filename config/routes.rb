Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :videos, only: [:index, :show, :create]

  post 'rentals/checkout', to: 'rentals#checkout'
  post 'rentals/checkin', to: 'rentals#checkin'

  resources :customers, only: [:index]
end
