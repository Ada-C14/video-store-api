Rails.application.routes.draw do
  # get 'videos/index'
  # get 'videos/show'

  resources :customers, only [:index, :show]


end
