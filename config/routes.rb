# config/routes.rb
Rails.application.routes.draw do
  get 'signup', to: 'signups#new', as: 'signup'
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
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'items#home'

  # Auth0 routes
  get '/auth/auth0', as: 'auth0_login'
  get '/auth/auth0/callback', to: 'sessions#create'
  get '/auth/failure', to: 'auth0#failure'
  get '/auth/logout', to: 'sessions#destroy', as: 'signout'


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

  resources :items do
    resource :chatroom do
      resources :messages, only: [:create, :destroy]
    end
    collection do
      get 'home'
    end
    member do
      patch :image_upload
      get 'pickup_request'


    end
  end

  patch 'time_slots/:id/mark_unavailable', to: 'time_slots#mark_unavailable', as: 'mark_unavailable_time_slot'
  patch "/items/:id/mark_unavailable", to: "items#mark_unavailable", as: 'mark_unavailable_item'
  get 'items/by_type/:type', to: 'items#by_type', as: :items_by_type
  resources :items, except: :show # Exclude the show action from the resources

  # Login routes
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  # About Us route
  get 'about', to: 'pages#about', as: 'about'

  # Contact Us route
  get 'contact', to: 'pages#contact', as: 'contact'
end
