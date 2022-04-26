class ApplicationController < ActionController::Base
  before_action :set_locale

  include SessionsHelper
  include CartsHelper
  include Pagy::Backend

  rescue_from CanCan::AccessDenied do
    flash[:warning] = t "admin_index.can_not_accesss"
    redirect_to root_url
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "carts.needs_login"
    redirect_to login_url
  end
end
