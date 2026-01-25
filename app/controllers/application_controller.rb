class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_forgery_protection

  protected

  def configure_permitted_parameters
    profile_fields = %i[first_name last_name job_title company bio theme palette]
    devise_parameter_sanitizer.permit(:sign_up, keys: profile_fields)
    devise_parameter_sanitizer.permit(:account_update, keys: profile_fields)
  end
end
