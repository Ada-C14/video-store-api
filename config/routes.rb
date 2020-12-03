Rails.application.routes.draw do

  resources :customers, only: [:index, :show, :create]
  resources :videos, only: [:index, :show, :create]

  post '/rentals/check-out', to: 'rentals#check_out', as: 'check-out'
  post '/rentals/check-in', to: 'rentals#check_in', as: 'check-in'
end
