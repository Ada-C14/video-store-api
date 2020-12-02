Rails.application.routes.draw do
  get 'rentals/create'
  get 'rentals/destroy'

  resources 'videos', only: [:index, :show, :create]
  resources 'customers', only: [:index, :show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/zomg', to: 'application#test'
end
