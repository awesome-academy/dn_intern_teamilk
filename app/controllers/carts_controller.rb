class CartsController < ApplicationController
  before_action :cart_current, :find_product_detail, only: %i(create)

  def index
    @products = {}
    cart_current.each do |product_detail_id, quantity|
      product_detail = ProductDetail.find_by id: product_detail_id
      @products[product_detail] = quantity if product_detail
    end
  end

  def create
    add_to_cart @product_detail.id
    flash[:success] = t ".add_item_to_cart_succes"
    redirect_to cart_path
  end

  private

  def cart_current
    session[:carts] ||= {}
  end

  def add_to_cart product_detail_id
    cart_current[product_detail_id] = 1
  end

  def find_product_detail
    @product_detail = ProductDetail.find_by(id: params[:product_detail_id])
    return if @product_detail

    flash[:danger] = t "carts.create.not_found_product"
    redirect_to cart_path
  end
end