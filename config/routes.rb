Rails.application.routes.draw do
  root 'home#index'
  
  devise_for :users
  resources :lessons do
    resources :bookings
  end
  resources :users do 
    resources :schedules
  end
  
end
