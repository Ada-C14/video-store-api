Rails.application.routes.draw do
  resources :videos, only: [:index, :show, :create]
  resources :customers, only: [:index]

  post "/rentals/check-out", to: "rentals#check_out", as: "check_out"
  post "/rentals/check-in", to: "rentals#check_in", as: "check_in"
end
