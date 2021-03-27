Rails.application.routes.draw do
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
  end
  devise_for :users, skip: [:registrations]
  root to: 'static#homepage'
end

