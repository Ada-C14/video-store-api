Rails.application.routes.draw do
  post 'rentals/check-out', to: "rentals#check_out", as: "check_out"
  resources :videos, only: [:index, :show, :create]
  resources :customers, only: [:index, :show]
end
