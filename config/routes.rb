Rails.application.routes.draw do
  resources :customers, only: [:index, :show, :create]
  resources :videos, only: [:index, :show, :create]
end
