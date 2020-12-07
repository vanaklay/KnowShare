Rails.application.routes.draw do
  root 'chatrooms#index'
  
  devise_for :users
  resources :lessons do
    resources :bookings
  end
  resources :users do 
    resources :schedules
    resources :chatrooms, only: [:index, :show, :create]
  end
  

  get '/contact' => 'static_pages#contact'
  
end
