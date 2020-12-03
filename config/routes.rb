Rails.application.routes.draw do
  root 'home#index'
  
  devise_for :users
  resources :lessons
  resources :users
  resources :bookings
end
