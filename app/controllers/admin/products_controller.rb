class Admin::ProductsController < Admin::BaseController
  before_action :get_list_products, only: :index

  def index
    @pagy, @pagy_children_products =
      pagy @list_product.children_products, items: Settings.number.digits_6
  end
end
