class Admin::UsersController < ApplicationController
  def index
    @users = User.where role: :client
  end
end
