class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger, :error, :notice, :alert
  
  # Allows to verify each requests with authenticity token sent to the application, with exception for added parameters to users (username, avatar)
  protect_from_forgery with: :exception

  before_action :configure_permitted_params, if: :devise_controller?

  private

  # Configure the authorization of params for controller devise only on sign up and update pages 
  def configure_permitted_params

    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :avatar, :email, :password)}

    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :avatar, :email, :password, :current_password) }

  end

end
