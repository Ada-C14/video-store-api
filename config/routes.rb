Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  post 'rentals/check_in_rental', as: 'check_in'
  resources :rentals, only: [:create, :check_in_rental]
  resources :customers, only: [:index, :show, :create]
  resources :videos, only: [:index, :show, :create]

end
