class Admin::BaseController < ApplicationController
  before_action :login?, :admin?

  def index; end

  private
  def login?
    @current_user = User.find_by(id: session[:user_id])
    return if @current_user

    flash[:danger] = t "admin_index.not_logged_in"
    redirect_to root_url
  end

  def admin?
    return if @current_user.admin?

    flash[:danger] = t "admin_index.can_not_accesss"
    redirect_to root_url
  end

  def get_list_products
    @list_product = Product.search_product_by_name(params[:name])
    return unless @list_product.empty?

    flash.now[:warning] = t "admin.not_found"
  end
end
