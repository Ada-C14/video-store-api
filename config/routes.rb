Rails.application.routes.draw do
  resources :videos, only: [:index, :show, :create]
  resources :customers, only: [:index]

  post "/rentals/check_in", to: "rentals#check_in", as: "check-in"
end
