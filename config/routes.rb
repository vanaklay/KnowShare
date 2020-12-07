Rails.application.routes.draw do
  root 'home#index'
  get '/contact' => 'static_pages#contact'

  devise_for :users

  resources :users do 
    resources :schedules
  end
  
  resources :lessons do
    resources :bookings do 
      resources :chatrooms, only: [:index, :show, :create]
    end 
  end
  
  resources :messages, only:[:create]

  # ActionCable
  mount ActionCable.server => '/cable'

end
