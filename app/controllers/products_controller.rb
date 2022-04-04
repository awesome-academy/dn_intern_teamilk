class ProductsController < ApplicationController
  before_action :find_product, only: :show

  def index
    @pagy, @products = pagy Product.children_products,
                            items: Settings.number.digits_6
  end

  def show
    @product_details = @product.product_details.sortSizeAsc
    return if @product_details.present?

    flash[:danger] = t "product.out_of_stock"
    redirect_to products_path
  end

  private

  def find_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "product.product_not_found"
    redirect_to root_path
  end
end
