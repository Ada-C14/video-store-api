Rails.application.routes.draw do
  post 'rentals/check-out', to: 'rentals#check_out_rental'
  post 'rentals/check_in_rental'
  # resources :rentals, only: [:create]
  resources :customers, only: [:index, :show, :create]
  resources :videos, only: [:index, :show, :create]
end
