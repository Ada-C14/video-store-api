Rails.application.routes.draw do
  get 'rentals/index'
  get 'rentals/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :videos, only: [:index, :show, :create]
  resources :customers, only: [:index, :show]
  resources :rentals

  post '/rentals/check-out', to: "rentals#check_out", as: "checkout"
  post '/rentals/check-in', to: "rentals#check_in", as: "checkin"

  # get "/zomg", to: "videos#zomg"
  
end
