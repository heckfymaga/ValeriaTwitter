Rails.application.routes.draw do
  devise_for :users
  resources :posts do #адрес -> контроллер
    collection do
      get :subscribes
    end
  end
  get 'about', action: :about, controller: 'application'
  resources :categories, only: [:show] do
    member do
      patch :subscribe
    end
  end
  resources :tags, only: [:show]
  root 'posts#index'

  resources :users, only: [:show] do
    member do
      patch :subscribe
    end
  end

  namespace :admin do
    resources :users, only: [:destroy]
  end
  namespace :head do
    resources :categories, except: [:show]
    resources :users, only: [] do
      member do
        get :desk
        post :set
        post :assign
        post :dismiss
      end
    end
  end
end
