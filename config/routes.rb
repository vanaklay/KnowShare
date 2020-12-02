Rails.application.routes.draw do
  
  root 'lessons#index'
  
  devise_for :users
  resources :lessons
  resources :users
end
