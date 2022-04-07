class OrdersController < ApplicationController
  before_action :logged_in_user
  def new
    @default_address = current_user.addresses.first
    @products = {}
    cart_current.each do |product_detail_id, quantity|
      product_not_found product_detail_id
      @products[@product_detail] = quantity if @product_detail
    end
  end

  private

  def product_not_found product_detail_id
    @product_detail = ProductDetail.find_by id: product_detail_id
    return @product_detail if @product_detail

    delete_cart product_detail_id
    flash[:danger] = t("product.out_of_stock")
    redirect_to cart_path
  end
end
