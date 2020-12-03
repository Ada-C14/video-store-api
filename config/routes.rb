Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :customers, only: [:index, :show]

  resources :videos, only:[:index, :show, :create]
  post '/rentals/checkout', to: 'videos#checkout', as: "checkout"
  post '/rentals/checkin', to: 'videos#checkin', as: "checkin"
end
