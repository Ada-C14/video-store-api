Rails.application.routes.draw do

  get 'customers/index'
  resources :customers, only: [:index]
  resources :videos
end
