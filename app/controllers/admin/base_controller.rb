class Admin::BaseController < ApplicationController
  before_action :login?, :admin?

  authorize_resource class: Admin::BaseController

  def index; end

  private
  def login?
    return if user_signed_in?

    flash[:danger] = t "admin_index.not_logged_in"
    redirect_to root_url
  end

  def admin?
    return if current_user.admin?

    flash[:danger] = t "admin_index.can_not_accesss"
    redirect_to root_url
  end

  def get_list_products
    @search = Product.ransack(params[:q])
    @list_product = @search.result
    return unless @list_product.empty?

    flash.now[:warning] = t "admin.not_found"
  end
end
