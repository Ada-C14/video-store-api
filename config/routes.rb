Rails.application.routes.draw do

  resources :videos, only: [:index, :show, :create]
  resources :customers, only: [:index, :show, :create]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post "/rentals/check_out", to: "rentals#check_out", as: "check_out"
  post "/rentals/check_in", to: "rentals#check_in", as: "check_in"

end
