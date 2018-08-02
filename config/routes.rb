Rails.application.routes.draw do
  root "home#index"
  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete '/logout',  to: 'sessions#destroy'
  resources :home, only: :index
  resources :categories, only: :show
  resources :books, only: :show
  resources :borrows, only: :create
  namespace :admin do
    resources :categories
    resources :publishers
    resources :authors
    resources :books
    resources :users
    resources :borrows, except: %i(create update)
  end
end
