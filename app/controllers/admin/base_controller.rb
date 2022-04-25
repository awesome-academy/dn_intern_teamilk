class Admin::BaseController < ApplicationController
  before_action :login?, :admin?

  def index; end

  private
  def login?
    return if current_user

    flash[:danger] = t "admin_index.not_logged_in"
    redirect_to root_url
  end

  def admin?
    return if current_user.admin?

    flash[:danger] = t "admin_index.can_not_accesss"
    redirect_to root_url
  end

  def set_flag_admin_search
    return if params[:name].to_s.blank?

    cookies[:id_flag] = 1
    cookies[:content_flag] = params[:name]
  end

  def get_list_products
    set_flag_admin_search
    @list_product = Product.search_product_by_name(params[:name])
    return unless @list_product.empty?

    flash.now[:warning] = t "admin.not_found"
  end
end
