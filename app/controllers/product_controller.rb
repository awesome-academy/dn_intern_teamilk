class ProductController < ApplicationController
  def index
    @pagy, @products = pagy Product.list_products, items: 6
  end
end
