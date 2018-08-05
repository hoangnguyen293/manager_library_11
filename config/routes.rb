Rails.application.routes.draw do
  root "home#index"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  resources :home, only: :index
  resources :categories, only: :show do
    member do
      get :load_more
    end
  end
  resources :books, only: :show
  resources :borrows, only: :create
  resources :comments, only: :create
  resources :authors, only: :show do
    member do
      get :load_more
    end
  end
  resources :search, only: :index
  resources :account_activations, only: :edit
  resources :password_resets, except: %i(index show destroy)
  resources :users, except: %i(new create)
  namespace :admin do
    get "", to: "books#index"
    resources :categories
    resources :publishers
    resources :authors
    resources :books do
      collection do
        get :search
      end
    end
    resources :users
    resources :borrows, except: %i(create update) do
      collection do
        get :search
      end
    end
    resources :comments, only: %i(index destroy)
  end
end
