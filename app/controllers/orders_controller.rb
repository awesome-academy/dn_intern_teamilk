class OrdersController < ApplicationController
  include OrdersHelper
  # before_action :logged_in_user
  load_and_authorize_resource
  before_action :find_order_by_id, only: %i(show destroy update)
  before_action :change_status, only: :destroy

  def index
    @pagy, @orders = pagy Order.list_orders_of_user(current_user.id)
                               .sort_by_day,
                          items: Settings.number.digits_6
  end

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
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t ".has_err"
    redirect_to new_order_url
  end

  def show_by_status
    @pagy, @orders = pagy Order.list_orders_of_user(current_user.id)
                               .show_by_status(params[:id_status]).sort_by_day,
                          items: Settings.number.digits_6
    render "index"
  end

  def show; end

  def destroy; end

  def update
    ActiveRecord::Base.transaction do
      @order.update!(status: "success")
    end
    flash[:success] = t "orders.create.sucess_order_status"
    redirect_to orders_url
  rescue NoMethodError
    flash[:danger] = t "orders.create.has_err"
    redirect_to orders_url
  end

  private

  def params_new_order
    order_params_address
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

  def find_order_by_id
    @order = current_user.orders.find_by id: params[:id]
    return @order if @order

    flash[:danger] = t("carts.create.not_found_product")
    redirect_to cart_path
  end

  def change_status
    ActiveRecord::Base.transaction do
      @order.update!(status: 5)
    end
    flash[:success] = t ".success_order"
    redirect_to orders_url
  rescue NoMethodError
    flash[:danger] = t ".has_err"
    redirect_to orders_url
  end
end
