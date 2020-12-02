Rails.application.routes.draw do
  get 'rentals/create'
  get 'rentals/destroy'
  get 'videos/index'
  get 'videos/show'
  get 'videos/create'
  get 'customers/index'
  get 'customers/show'
  get 'video/index'
  get 'video/show'
  get 'video/create'
  get 'customer/index'
  get 'customer/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/zomg', to: 'application#test'
end
