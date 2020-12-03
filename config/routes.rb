Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  post 'rentals/check_in_rental'
  resources :rentals, only: [:create]
  resources :customers, only: [:index, :show, :create]
  resources :videos, only: [:index, :show, :create]

end
