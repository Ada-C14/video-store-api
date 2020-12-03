Rails.application.routes.draw do

  resources :videos, only: [:index, :show, :create]
  resources :customers, only: [:index]
  post '/rentals/check-out', to: 'rentals#check_out', as: 'check_out'
end
