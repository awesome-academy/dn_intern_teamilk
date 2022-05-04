class Admin::CategoriesController < Admin::BaseController
  before_action :get_list_products, only: :index

  authorize_resource class: Admin::CategoriesController

  def index
    @pagy, @pagy_parent_products =
      pagy @list_product.parent_products, items: Settings.number.digits_6
  end

  def create
    @product = Product.new
  end
end
