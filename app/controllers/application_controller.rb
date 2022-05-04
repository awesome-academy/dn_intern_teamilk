class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  include SessionsHelper
  include CartsHelper

  rescue_from CanCan::AccessDenied, with: :access_denied
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  protected

  def configure_permitted_parameters
    user_infor = %i(email name phone password password_confirmation remember_me)
    devise_parameter_sanitizer.permit :sign_up, keys: user_infor
    devise_parameter_sanitizer.permit :account_update, keys: user_infor
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def access_denied
    if current_user.nil?
      flash[:danger] = t "access_denied_login"
      return redirect_to login_path
    end

    flash[:danger] = t "access_denied"
    redirect_to root_path
  end

  def not_found
    flash[:danger] = t "not_found"
    redirect_to root_path
  end

  include Pagy::Backend
end
