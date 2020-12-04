Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post "/rentals/check-out", to: "rentals#check_out", as: "checkout"
  post "/rentals/check-in", to: "rentals#check_in", as: "checkin"

  resources :customers, only: [:index]
  resources :videos, only: [:index, :show, :create]
end
