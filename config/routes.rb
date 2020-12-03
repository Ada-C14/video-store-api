Rails.application.routes.draw do
  post 'rentals/check-out', to: 'rentals#create', as: 'check_out'
  post 'rentals/check-in', to: 'rentals#destroy', as: 'check_in'

  resources 'videos', only: [:index, :show, :create]
  resources 'customers', only: [:index]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/zomg', to: 'application#test'
end
