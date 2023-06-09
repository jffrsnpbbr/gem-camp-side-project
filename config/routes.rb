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
      resources :lottery, only: %i[index show] do
        member do
          post :bet
        end
      end
    end
  end

  constraints AdminDomainConstraint.new do
    namespace :admin, path: '/' do
      root controller: :home, action: :index

      resources :users, only: :index
      resources :items do
        member do
          patch :state_start
          patch :state_pause
          patch :state_end
          patch :state_cancel
        end
      end
      resources :bets, only: :index
      resources :winners, only: :index do
        member do
          put :state_submit
          put :state_pay
          put :state_ship
          put :state_deliver
          put :state_share
          put :state_publish
          put :state_unpublish
        end
      end

      resources :categories
      resources :offers
    end
  end
end
