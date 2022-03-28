class ProductController < ApplicationController
  def index
    @pagy, @products = pagy Product.children_products,
                            items: Settings.number.digits_6
  end
end
