Rails.application.routes.draw do

  resources :videos, only: [:index, :show, :create]
  resources :customers, only: [:index]

  resources :rentals, only: [:create]
  post "/rentals/checkin", to: 'rentals#update', as: 'checkin'
end
