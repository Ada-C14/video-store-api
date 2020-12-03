Rails.application.routes.draw do
  post 'rentals/check-out', to: "rentals#check_out", as: "check_out"
  resources :videos, only: [:index, :show, :create]
  resources :customers, only: [:index, :show]
  post "/rentals/check-in", to: "rentals#check_in", as: "check_in"
end
