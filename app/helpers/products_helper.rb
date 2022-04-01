module ProductsHelper
  def load_fisr_product
    @load_first = @product_details.first
    @status_quantity = if @load_first.quantity.positive?
                         t "product.stocking"
                       else
                         t "product.out_of_stock"
                       end
  end
end
