Rails.application.routes.draw do
  get 'rentals/check_in', to: "rentals#check_in", as: "rentals_check_in"
  get 'rentals/check_out', to: "rentals#check_out", as: "rentals_check_out"
  resources :videos, only: [:index, :show, :create]
  resources :customers, only: [:index, :show, :create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
