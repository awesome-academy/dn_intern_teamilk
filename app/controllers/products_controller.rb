class ProductsController < ApplicationController
  load_and_authorize_resource

  before_action :get_parent_products, only: :index
  before_action :find_product, only: %i(show destroy)

  def index
    @q = Product.ransack(params[:q])
    @children_products = @q.result(distinct: true).children_products

    @pagy, @pagy_children_products =
      pagy @children_products, items: Settings.number.digits_6
  end

  def create
    @product = Product.create product_params
    if @product.save
      flash[:success] = t "admin.products.add_success"
    else
      flash[:danger] = t "admin.products.add_faild"
    end
    load_after_action
  end

  def show
    @product_details = @product.product_details.sortSizeAsc
    # return if @product_details.present?

    # flash[:danger] = t "product.out_of_stock"
    # redirect_to products_path
  end

  def destroy
    if @product.destroy
      flash[:success] = t "admin.products.product_del_success"
    else
      flash[:danger] = t "admin.products.product_del_failed"
    end
    load_after_action
  end

  # =========================================================
  private
  def load_after_action
    if @product.product_id.nil?
      redirect_to admin_categories_path
    else
      redirect_to admin_products_path
    end
  end

  def product_params
    params.require(:product).permit(:name, :image, :description, :product_id)
  end

  def find_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "product.product_not_found"
    redirect_to root_path
  end

  def get_parent_products
    @parent_products = Product.ransack(product_id_null: true).result
    return unless @parent_products.empty?

    flash[:danger] = t "product.parent_product_not_found"
    redirect_to root_path
  end
end
