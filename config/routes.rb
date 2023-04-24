Rails.application.routes.draw do
  devise_for :users, path: ''

  constraints ClientDomainConstraint.new do
    root controller: :home, action: :index
  end

  constraints AdminDomainConstraint.new do
    namespace :admin, path: '/' do
      root controller: :home, action: :index
    end
  end
end
