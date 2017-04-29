Rails.application.routes.draw do
  
  get '/contact', to: 'static_pages#contact'
  get '/help',    to: 'static_pages#help', as: 'helf'
  get '/about',   to: 'static_pages#about'
  get '/signup',  to: 'users#new'
  root 'static_pages#home'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
