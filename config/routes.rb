Rails.application.routes.draw do

  resources :customers, only: [:index, :show]

  resources :videos, only: [:index, :show]

end
