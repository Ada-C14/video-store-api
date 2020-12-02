Rails.application.routes.draw do

  resources :videos, only: [:index, :show, :create]
  resources :customers, only: [:index]

end
