Rails.application.routes.draw do
  resources :videos, only: [:index]
  # get "/zomg", to: "videos#zomg"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
