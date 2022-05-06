class ApplicationController < ActionController::Base
  before_action :set_locale, :search
  before_action :configure_permitted_parameters, if: :devise_controller?

  include CartsHelper
  include Pagy::Backend

  rescue_from CanCan::AccessDenied do
    flash[:warning] = t "admin_index.can_not_accesss"
    redirect_to root_url
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [:email, :password])
    user_params = [:name, :email,
                   :phone, :password,
                   :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: user_params
    devise_parameter_sanitizer.permit :account_update, keys: user_params
  end

  private
  def search
    @search = Product.ransack params[:q]
    @children_products = @search.result.children_products
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if user_signed_in?

    flash[:danger] = t "carts.needs_login"
    redirect_to login_url
  end
end
