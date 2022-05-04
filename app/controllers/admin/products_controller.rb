class Admin::ProductsController < Admin::BaseController
  before_action :get_list_products, only: :index

  authorize_resource class: Admin::ProductsController

  def index
    @pagy, @pagy_children_products =
      pagy @list_product.children_products, items: Settings.number.digits_6
  end

  def create
    @product = Product.new
  end
end
