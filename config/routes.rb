Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  get '/contact', to: 'static_pages#contact'
  get '/help',    to: 'static_pages#help', as: 'helf'
  get '/about',   to: 'static_pages#about'
  get '/signup',  to: 'users#new'
  post '/signup', to: 'users#create'
  root 'static_pages#home'
  
  get '/login',     to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    member do
      get :following, :followers
      # /users/1/following
      # /users/1/followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  # GET	    /password_resets/new	        new	    new_password_reset_path
  # POST	  /password_resets	            create	password_resets_path
  # GET	    /password_resets/<token>/edit	edit	  edit_password_reset_path(token)
  # PATCH	  /password_resets/<token>	     update	password_reset_url(token)
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end
