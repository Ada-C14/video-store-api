Rails.application.routes.draw do
  resources :videos, only: [:index, :show, :create]
end
