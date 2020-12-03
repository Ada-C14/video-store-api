Rails.application.routes.draw do
  get 'videos/index'
  get 'customers/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/zomg", to: 'application#zomg'

  resources :customers, only: [:index, :show, :create]
  resources :videos, only: [:index, :show, :create]
end
