Rails.application.routes.draw do
  post 'rentals/check-out', to: 'rentals#check_out_rental'
  post 'rentals/check-in', to: 'rentals#check_in_rental'
  resources :customers, only: [:index, :show, :create]
  resources :videos, only: [:index, :show, :create]
end
