class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  add_flash_types :success, :danger, :info, :warning
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def current_controller?(names)
    names.include?(params[:controller]) unless params[:controller].blank? || false
  end
  def about
  end

  helper_method :current_controller?


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password,
                                                               :password_confirmation, :remember_me, :avatar, :avatar_cache, :remove_avatar) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :password,
                                                                      :password_confirmation, :current_password, :avatar, :avatar_cache, :remove_avatar) }
  end
end
