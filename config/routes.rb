Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  devise_scope :user do
    authenticated :user do
      root 'dashboard#index', as: :authenticated_root
    end

    unauthenticated do
      root 'home#index', as: :unauthenticated_root
    end
  end

  scope :api do
    scope :v1 do
      resources :users, only: [:index, :destroy]
      resources :recipes, only: [:show, :index]
      resources :profiles
    end
  end
end
