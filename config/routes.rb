Rails.application.routes.draw do
  root 'home#index'
  get '/tarifs' => 'static_pages#pricing', as: 'pricing'
  get '/cgv' => 'static_pages#terms', as: 'terms'
  get '/contact' => 'static_pages#contact'
  get '/l-équipe' => 'static_pages#team', as: 'team'

  scope(path_names: { new: 'nouveau', edit: 'édition' }) do
    devise_for :users, path: 'utilisateurs', param: :username

    resources :users, path: 'utilisateurs', param: :username do
      resources :schedules, path: 'horaires'
      resources :student_bookings, only: [:index], path: 'réservations-côté-élève'
      resources :teacher_bookings, only: [:index], path: 'réservations-côté-prof'
      resources :teacher_lessons, only: [:index], path: 'leçons-prof'
      resources :user_credit_orders, only: [:index], path: 'commandes-de-crédits'
    end

    resources :lessons, path: 'leçons' do
      resources :teachers, only: [:show], path: 'professeurs'
      resources :bookings, path: 'réservations' do
        resources :chatrooms, only: %i[show create], path: 'tchat'
      end
    end

    resources :messages, only: [:create]
    resources :credit_orders, only: %i[index new create], path: 'commandes-de-crédits'
    resources :contacts, only: %i[create new], path: 'contact'
    resources :lesson_searches, only: [:index], path: 'recherche'

    # ActionCable
    mount ActionCable.server => '/cable'

    # Admin
    namespace :admin do
      root 'facade#index'
      resources :users, path: 'utilisateurs', param: :username
      resources :lessons, path: 'leçons'
      resources :bookings, path: 'réservations'
      resources :credit_orders, only: [:index], path: 'commandes-de-crédits'
    end
  end
end
