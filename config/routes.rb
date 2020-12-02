Rails.application.routes.draw do
  get 'rentals/create'
  get 'videos/index'
  get 'videos/show'

  resources :customers, only: [:index, :show]
  post 'customers/create'
  # get 'customers/index'
  # get 'customers/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
