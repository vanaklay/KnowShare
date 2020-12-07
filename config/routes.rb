Rails.application.routes.draw do
  root 'home#index'
  
  devise_for :users
  resources :lessons do
    resources :bookings do 
      resources :chatrooms, only: [:index, :show, :create]
    end 
  end

  resources :users do 
    resources :schedules
  end
  resources :messages, only:[:create]
  
  get '/contact' => 'static_pages#contact'
  
end
