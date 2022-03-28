class ProductController < ApplicationController
  def index
    @pagy, @products = pagy Product.list_products, items: Settings.number.digits_6;
  end
end
