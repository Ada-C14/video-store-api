Rails.application.routes.draw do
  get 'rentals/create'
  resources :videos, only: [:index, :show, :create]
  resources :customers, only: [:index, :show]
end
