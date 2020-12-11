require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  root 'home#index'
  get '/pricing' => 'static_pages#pricing'
  get '/terms' => 'static_pages#terms'
  get '/contact' => 'static_pages#contact'
  get '/team' => 'static_pages#team'

  devise_for :users, param: :username

  resources :users, param: :username do
    resources :schedules
    resources :student_bookings, only: [:index]
    resources :teacher_bookings, only: [:index]
    resources :teacher_lessons, only: [:index]
    resources :user_credit_orders, only: [:index]
  end

  resources :lessons, path: 'leçons' do
    resources :teachers, only: [:show]
    resources :bookings do
      resources :chatrooms, only: %i[show create]
    end
  end

  resources :messages, only: [:create]
  resources :credit_orders, only: %i[index new create]
  resources :contacts, only: %i[create new]
  resources :lesson_searches, only: [:index]

  # Only allow authenticated users to get access
  # to the Sidekiq web interface
  devise_scope :user do
    authenticated :user do
      mount Sidekiq::Web => '/sidekiq'
    end
  end

  # ActionCable
  mount ActionCable.server => '/cable'

  # Admin
  namespace :admin do
    root 'facade#index'
    resources :users, param: :username
    resources :lessons
    resources :bookings
    resources :credit_orders, only: [:index]
  end
end
