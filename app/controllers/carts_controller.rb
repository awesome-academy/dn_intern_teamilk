class CartsController < ApplicationController
  include CartsHelper
  before_action :find_product_detail, only: %i(create destroy update)
  before_action :delete_cart, only: :destroy
  before_action :check_quantity_exceeds_amount, only: :update
  skip_before_action :verify_authenticity_token, only: :update

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

  def update
    update_quantity_cart params[:product_detail_id],
                         params[:quantity], @product_detail.quantity
    @quantity = params[:quantity].to_i

    respond_to do |format|
      format.js
    end
  end

  def destroy
    respond_to do |format|
      format.html{redirect_to request.referer}
      format.js
    end
  end

  private

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

  def update_quantity_cart product_detail_id, quantity, product_quantity
    if cart_current.key?(product_detail_id)
      cart_current[product_detail_id] = if product_quantity < quantity.to_i
                                          Settings.number.digits_1
                                        else
                                          quantity.to_i
                                        end
    else
      cart_current[product_detail_id] = Settings.number.digits_1
    end
  end

  def check_quantity_exceeds_amount
    return unless @product_detail.quantity < params[:quantity].to_i

    flash[:danger] = t("carts.update..exceed",
                       product_name: @product_detail.product_name)
    render js: "window.location = '#{cart_path}'"
  end
end
