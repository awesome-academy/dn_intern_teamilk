class OrdersController < ApplicationController
  before_action :logged_in_user

  def new
    @default_address = current_user.addresses.first
    @products = {}

    if cart_current.empty?
      flash[:danger] = t ".no_proc_in_cart"
      redirect_to cart_url
    else
      cart_current.each do |product_detail_id, quantity|
        product_not_found product_detail_id
        @products[@product_detail] = quantity if @product_detail
      end
    end
  end

  def create
    @new_order = current_user.orders.new params_new_order

    new_order_details
    ActiveRecord::Base.transaction do
      @new_order.save!
    end
    cart_current.clear
    flash[:success] = t ".success_order"
    redirect_to root_url
  rescue NoMethodError
    flash[:danger] = t ".has_err"
    redirect_to new_order_url
  end

  private

  def params_new_order
    params.permit :address_id
  end

  def new_order_details
    cart_current.each do |product_detail_id, quantity|
      product_not_found product_detail_id
      @new_order.order_details.build(
        quantity: quantity,
        price: @product_detail.price,
        product_detail_id: @product_detail.id
      )
    end
  end

  def product_not_found product_detail_id
    @product_detail = ProductDetail.find_by id: product_detail_id
    return @product_detail if @product_detail

    delete_cart product_detail_id
    flash[:danger] = t("product.out_of_stock")
    redirect_to cart_path
  end
end
