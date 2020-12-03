Rails.application.routes.draw do
  post 'rentals/check-in', to: "rentals#check_in", as: "rentals_check_in"
  post 'rentals/check-out', to: "rentals#check_out", as: "rentals_check_out"
  get 'rentals/overdue', to: "rentals#overdue"
  get 'videos/:id/current', to: "videos#currently_checked_out"
  get 'videos/:id/history', to: "videos#checkout_history"
  resources :videos, only: [:index, :show, :create]
  resources :customers, only: [:index, :show, :create]
end
