Rails.application.routes.draw do
  get 'rentals/create'
  resources :videos, only: [:index, :show, :create]
  get 'customers/index'
  get 'customers/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
