Rails.application.routes.draw do
  resources :videos, only: [:index, :show]

  resources :customers, only: [:index]
end
