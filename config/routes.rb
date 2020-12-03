Rails.application.routes.draw do
  post 'rentals/check-out', to: 'rentals#create', as: 'check-out'
  post 'rentals/check-in', to: 'rentals#destroy', as: 'check-in'

  resources 'videos', only: [:index, :show, :create]
  resources 'customers', only: [:index, :show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/zomg', to: 'application#test'
end
