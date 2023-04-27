class HomeController < ApplicationController
  before_action :check_if_login
  def index
  end

  private

  def check_if_login
    unless current_user
      redirect_to login_path
    end
  end
end
