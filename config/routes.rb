Rails.application.routes.draw do
  devise_for :users
  
  root controller: :home, action: :index
end
