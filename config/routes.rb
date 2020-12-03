Rails.application.routes.draw do

  resources :customers, only: :index
  resources :videos, only: [:index, :show, :create]

  post '/rentals/check-in', to: 'rentals#check_in', as: 'check-in'
  post '/rentals/check-out', to: 'rentals#check_out', as: 'check-out'


  # auto-populated routes
  # get 'customers/index'
  # get 'videos/index'
  # get 'videos/show'
  # get 'videos/create'

  # Wave 0 test:
  # get '/zomg', to: 'application#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


end
