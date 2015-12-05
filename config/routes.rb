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
      resources :users, only: [:index, :destroy, :show, :create, :update]
      resources :recipes, only: [:create, :show, :index, :update, :destroy]
      resources :followerships
      resources :profiles
      resources :notes, only: [:create, :update, :destroy]
    end
  end
end
