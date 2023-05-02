Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :regions, only: [:index, :show], defaults: { format: :json } do
        resources :provinces, only: :index, defaults: { format: :json }
      end

      resources :provinces, only: [:index, :show], defaults: { format: :json } do
        resources :cities, only: :index, defaults: { format: :json }
      end

      resources :cities, only: [:index, :show], defaults: { format: :json } do
        resources :barangays, only: :index, defaults: { format: :json }
      end

      resources :barangays, only: [:index, :show], defaults: { format: :json }
    end
  end
  devise_for :users

  constraints ClientDomainConstraint.new do
    root controller: :home, action: :index
    devise_scope :user do

      get :register, controller: :registrations, action: :new
      get 'profile/edit', controller: :registrations, action: :edit

      get :login, controller: :sessions, action: :new
      delete :logout, controller: :sessions, action: :destroy

      get :profile, controller: :profile, action: :show
      resources :address_books, except: :show
    end
  end

  constraints AdminDomainConstraint.new do
    namespace :admin, path: '/' do
      root controller: :home, action: :show
    end
  end
end
