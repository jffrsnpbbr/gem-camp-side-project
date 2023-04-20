class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :phone_number, :password)}
      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :phone_number, :password, :current_password)}
      devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:username, :password, :remember_me)}
    end
end
