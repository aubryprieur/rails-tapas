Rails.application.routes.draw do
  # Health check (renvoie 200 si l'app démarre sans erreur)
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :admin do
      resources :users
      resources :admin_users
      resources :posts
      root to: "users#index"
    end

  get '/favorites', to: 'favorite_posts#index', as: 'favorites'
  resources :favorite_posts, only: [:create, :destroy]

  resources :posts do
    resources :likes
    resources :readings
    resources :calls
    resources :teams
    resources :rejections
    resources :comments
  end
  devise_for :users, skip: [:registrations]
  root to: 'static#homepage'
end

