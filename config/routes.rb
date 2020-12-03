Rails.application.routes.draw do
  get 'rentals/create'
  resources :videos, only: [:index, :show, :create]
  resources :customers, only: [:index, :show]
  post "/rentals/check_in", to: "rentals#check_in", as: "check_in"
end
