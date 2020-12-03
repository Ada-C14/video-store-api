Rails.application.routes.draw do
  # get 'customer/index'
  # get 'customer/show'
  # get 'customer/create'
  # get 'videos/index'
  # get 'videos/show'
  # get 'videos/create'
  resources :videos, only: [:index, :show, :create]
  resources :customers, only: [:index, :show, :create]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
