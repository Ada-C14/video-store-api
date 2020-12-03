Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # get '/videos', to: "videos#index", as: "videos"
  resources :videos, only: [:index, :show, :create]
end
