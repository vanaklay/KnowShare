Rails.application.routes.draw do
  root 'home#index'
  get '/tarifs' => 'static_pages#pricing'
  get '/terms' => 'static_pages#terms'
  get '/contact' => 'static_pages#contact'
  get '/team' => 'static_pages#team'

  devise_for :users

  resources :users do 
    resources :schedules
    resources :student_bookings, only: [:index]
    resources :teacher_bookings, only: [:index]
  end
  
  resources :lessons do
    resources :teachers, only: [:show]
    resources :bookings do 
      resources :chatrooms, only: [:show, :create]
    end 
  end
  
  resources :messages, only:[:create]
  resources :credit_orders, only:[:new, :create]
  resources :contacts, only:[:create, :new]

  # ActionCable
  mount ActionCable.server => '/cable'

  # Admin 
  namespace :admin do
    root 'facade#index'
    resources :users
    resources :lessons
    resources :bookings
  end
end
