Rails.application.routes.draw do
  post 'rentals/check_in', to: "rentals#check_in", as: "rentals_check_in"
  post 'rentals/check_out', to: "rentals#check_out", as: "rentals_check_out"
  resources :videos, only: [:index, :show, :create]
  resources :customers, only: [:index, :show, :create]
end
