Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # get 'customers/index'
  resources :customers, only: [:index]

  # get '/videos', to: "videos#index", as: "videos"
  resources :videos, only: [:index, :show, :create]

  post '/rentals/check-out', to: "rentals#check_out", as: "check_out"
end
