Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :regions, only: %i[index show], defaults: { format: :json } do
        resources :provinces, only: :index, defaults: { format: :json }
      end

      resources :provinces, only: %i[index show], defaults: { format: :json } do
        resources :cities, only: :index, defaults: { format: :json }
      end

      resources :cities, only: %i[index show], defaults: { format: :json } do
        resources :barangays, only: :index, defaults: { format: :json }
      end

      resources :barangays, only: %i[index show], defaults: { format: :json }
    end
  end

  constraints ClientDomainConstraint.new do
    root controller: :home, action: :index

    devise_for :users, controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions'
    }

    devise_scope :user do
      namespace :users do
        resource do
          get :sign_in, action: :new
          get :edit_user_registration, action: :edit
        end
      end

      get :profile, controller: :profile, action: :show
      get :invite, controller: 'profile/invite', action: :show
      resources :address_books, except: :show
    end
  end

  constraints AdminDomainConstraint.new do
    namespace :admin, path: '/' do
      root controller: :home, action: :index

      resources :users, only: :index
      resources :items
      resources :categories
    end
  end
end
