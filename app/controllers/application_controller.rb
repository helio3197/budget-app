class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :user

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar remove_avatar])
  end

  private

  def amount_negative?(value)
    value&.to_f&.negative?
  end

  def user
    @user = current_user
  end
end
