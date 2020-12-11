class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger, :error, :notice, :alert
  include ApplicationHelper
  
  # Allows to verify each requests with authenticity token sent to the application, with exception for added parameters to users (username, avatar)
  protect_from_forgery with: :exception

  before_action :configure_permitted_params, if: :devise_controller?
  before_action :set_locale

  private

  # Configure the authorization of params for controller devise only on sign up and update pages 
  def configure_permitted_params
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation)}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  def redirect_if_user_not_admin
    unless current_user.is_admin
      redirect_to root_path, danger: "Vous n'êtes pas administrateur de ce site !"
    end
  end

  def set_locale
    I18n.locale = "fr"
  end 

end
