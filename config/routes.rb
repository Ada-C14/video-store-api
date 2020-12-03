Rails.application.routes.draw do
  get 'customers/index'
  resources :videos, only: [:index]
end
