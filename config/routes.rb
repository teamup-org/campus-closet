# frozen_string_literal: true

Rails.application.routes.draw do
  get 'carousel/page'
  get 'welcome/page'
  resources :reviews
  resources :time_slots
  resources :requests
  resources :pickups
  resources :users
  resources :conditions
  resources :sizes
  resources :statuses
  resources :genders
  resources :types
  resources :colors
  resources :items
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root 'items#index'

  #OAuth Routes
  get '/auth/google_oauth2', as: 'google_login'
  get '/auth/:google_oauth2/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')
  get '/signout', to: 'sessions#destroy', as: 'signout'

  #Draft Routes
  get '/welcome', to: 'welcome#page'
  get '/carousel', to: 'carousel#page'

  # chat routes
  # mount ActionCable.server => '/cable'

  resources :users do
    patch 'update_user', on: :member
    member do
      get 'account_creation', to: 'users#account_creation'
      patch 'make_admin'
    end
  end

  get 'users/:id/student', to: 'users#show_student', as: 'user_student'
  get 'users/:id/donor', to: 'users#show_donor', as: 'user_donor'

  resources :items

  resources :items do
    resource :chatroom do
      resources :messages, only: [:create, :destroy]
    end
  end

  resources :items do
    member do
      patch :image_upload
    end
  end

  patch 'time_slots/:id/mark_unavailable', to: 'time_slots#mark_unavailable', as: 'mark_unavailable_time_slot'
  patch "/items/:id/mark_unavailable", to: "items#mark_unavailable", as: 'mark_unavailable_item'
  get 'items/by_type/:type', to: 'items#by_type', as: :items_by_type
  resources :items, except: :show # Exclude the show action from the resources

end
