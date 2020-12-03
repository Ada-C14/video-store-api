Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :videos, only: [:index, :show, :create]

  resources :customers, only: [:index]

  post '/rentals/check-out', to: 'rentals#checkout', as: 'checkout'
  post '/rentals/check-in', to: 'rentals#check_in', as: 'check_in'
  get '/rentals/overdue', to: 'rentals#overdue', as: 'overdue'


end
