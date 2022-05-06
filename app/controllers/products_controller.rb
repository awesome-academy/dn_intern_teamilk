class ProductsController < ApplicationController
  before_action :get_parent_products, :get_children_products, only: :index
  before_action :find_product, only: %i(show destroy)

  authorize_resource

  def index
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
    @parent_products = Product.ransack(product_id_null: 1).result
    return unless @parent_products.empty?

    flash[:danger] = t "product.parent_product_not_found"
    redirect_to root_path
  end

  def get_children_products
    return unless @children_products.children_products.empty?

    flash.now[:danger] = t "product.children_product_not_found"
  end
end
