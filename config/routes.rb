Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :videos, only: [:show, :index, :create]

  resources :customers, only: [:index]

  post "/rentals/check-out", to: "rentals#checkout", as: "checkout"

end
