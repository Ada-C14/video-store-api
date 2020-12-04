Rails.application.routes.draw do
  resources :videos, only: [:index, :show, :create]
  resources :customers, only: [:index]

  post "/rentals/check_out", to: "rentals#check_out", as: "check-out"
end
