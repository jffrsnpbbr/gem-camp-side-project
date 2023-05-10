# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :verify_promoter, only: [:new, :create]
  before_action :configure_sign_up_params, only: [:create]

  def create
    build_resource(sign_up_params)
    resource.parent = User.find_by(username: cookies[:promoter])
    resource.save
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :phone_number, :password, :password_confirmation])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:image, :username, :email, :phone_number, :password, :current_password])
  end

  def verify_promoter
    if params.include? :promoter
      if User.find_by(username: params[:promoter])
        cookies[:promoter] = params[:promoter]
      else
        flash[:notice] = "#{params[:promoter]} does not exist"
        redirect_to new_user_registration_path
      end
    end
  end
end
