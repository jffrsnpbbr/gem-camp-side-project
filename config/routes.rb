Rails.application.routes.draw do
  devise_for :users

  constraints ClientDomainConstraint.new do
    root controller: :home, action: :index
    devise_scope :user do

      get :login, controller: :sessions, action: :new
      delete :logout, controller: :sessions, action: :destroy
      get :register, controller: :registrations, action: :new

      resources :profile, only: :index
    end
  end

  constraints AdminDomainConstraint.new do
    namespace :admin, path: '/' do
      root controller: :home, action: :index
    end
  end
end
