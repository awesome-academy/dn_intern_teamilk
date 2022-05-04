class ProductsController < ApplicationController
  load_and_authorize_resource

  before_action :get_parent_products,
                :list_product_final_custom, only: :index
  before_action :find_product, only: %i(show destroy)

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
    @parent_products = Product.parent_products
    return unless @parent_products.empty?

    flash[:danger] = t "product.parent_product_not_found"
    redirect_to root_path
  end

  def list_product_final_custom
    if params[:sort_id]
      get_list_product_by_cookies
      list_product_after_filter
    else
      get_list_product_by_params
    end
    return unless @children_products.empty?

    flash.now[:danger] = t "product.children_product_not_found"
  end

  # =========================================================
  def get_children_product_by_name search_name
    @children_products = Product.search_product_by_name(search_name)
                                .children_products
    cookies[:id_flag] = 1
    cookies[:content_flag] = search_name
  end

  def get_children_product_by_parent_id parent_id
    @children_products = Product.search_product_by_parent_id(parent_id)
                                .children_products
    cookies[:id_flag] = 2
    cookies[:content_flag] = parent_id
  end

  def get_all_children_product
    @children_products = Product.children_products
    cookies.delete :id_flag
    cookies.delete :content_flag
  end

  def get_list_product_by_params
    if params[:name]
      get_children_product_by_name params[:name]
    elsif params[:parent_id]
      get_children_product_by_parent_id params[:parent_id]
    else
      get_all_children_product
    end
  end

  def get_list_product_by_cookies
    if cookies[:id_flag] == "1"
      get_children_product_by_name cookies[:content_flag]
    elsif cookies[:id_flag] == "2"
      get_children_product_by_parent_id cookies[:content_flag]
    else
      get_all_children_product
    end
  end

  def list_product_after_filter
    @children_products = if params[:sort_id] == "1"
                           @children_products.order(:name)
                         elsif params[:sort_id] == "2"
                           @children_products.order(name: :desc)
                         elsif params[:sort_id] == "3"
                           @children_products.order(:updated_at)
                         elsif params[:sort_id] == "4"
                           @children_products.order(updated_at: :desc)
                         end
  end
end
