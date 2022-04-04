class ProductsController < ApplicationController
  before_action :get_parent_products,
                :get_list_custom_childern_product, only: :index
  before_action :find_product, only: :show

  def index
    @pagy, @pagy_children_products =
      pagy @children_products, items: Settings.number.digits_6
  end

  def show
    @product_details = @product.product_details.sortSizeAsc
  end

  # =========================================================
  private
  def find_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "product.product_not_found"
    redirect_to root_path
  end

  def get_parent_products
    @parent_products = Product.parent_products
    return if @parent_products

    flash[:danger] = t "product.parent_product_not_found"
    redirect_to root_path
  end

  def get_list_custom_childern_product
    if params[:sort_id]
      get_flag_seach_product_cookies
      get_flag_filter_product
    else
      get_flag_seach_product_params
    end
    return if @children_products

    flash[:danger] = t "product.children_product_not_found"
    redirect_to root_path
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

  def get_flag_seach_product_params
    if params[:name]
      get_children_product_by_name params[:name]
    elsif params[:parent_id]
      get_children_product_by_parent_id params[:parent_id]
    else
      get_all_children_product
    end
  end

  def get_flag_seach_product_cookies
    if cookies[:id_flag] == "1"
      get_children_product_by_name cookies[:content_flag]
    elsif cookies[:id_flag] == "2"
      get_children_product_by_parent_id cookies[:content_flag]
    else
      get_all_children_product
    end
  end

  def get_flag_filter_product
    if params[:sort_id] == "1"
      @children_products = @children_products.order(:name)
    elsif params[:sort_id] == "2"
      @children_products = @children_products.order(name: :desc)
    elsif params[:sort_id] == "3"
      @children_products = @children_products.order(:updated_at)
    elsif params[:sort_id] == "4"
      @children_products = @children_products.order(updated_at: :desc)
    end
  end
end
