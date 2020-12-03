Rails.application.routes.draw do
  resources :videos, only: [:index, :show, :create]

  resources :customers, only: [:index]

  post '/rentals/check-out', to: 'rentals#check_out', as: 'checkout'

  post '/rentals/check-in', to: 'rentals#check_in', as: 'checkin'
end
