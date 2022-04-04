class CartsController < ApplicationController
  before_action :cart_current, only: :create
  before_action :find_product_detail, only: %i(create destroy)
  before_action :delete_cart, only: :destroy

  def show
    @products = {}
    cart_current.each do |product_detail_id, quantity|
      product_detail = ProductDetail.find_by id: product_detail_id
      @products[product_detail] = quantity if product_detail
    end
  end

  def create
    add_to_cart @product_detail.id.to_s
    flash[:success] = t ".add_item_to_cart_succes"
    redirect_to cart_path
  end

  def destroy
    respond_to do |format|
      format.html{redirect_to request.referer}
      format.js
    end
  end

  private

  def cart_current
    session[:carts] ||= {}
  end

  def add_to_cart product_detail_id
    if cart_current.key?(product_detail_id)
      cart_current[product_detail_id] += Settings.number.digits_1
    else
      cart_current[product_detail_id] = Settings.number.digits_1
    end
  end

  def find_product_detail
    @product_detail = ProductDetail.find_by(id: params[:product_detail_id])
    return if @product_detail

    flash[:danger] = t "carts.create.not_found_product"
    redirect_to cart_path
  end

  def delete_cart
    return unless cart_current.key?(params[:product_detail_id])

    cart_current.delete(params[:product_detail_id])
  end
end
