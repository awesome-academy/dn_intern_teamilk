module ProductsHelper
  def load_fisr_product
    return if @product_details.empty?

    @load_first = @product_details.first
    @status_quantity = if @load_first.quantity.positive?
                         t "product.stocking"
                       else
                         t "product.out_of_stock"
                       end
    @first_price = @load_first.price
    @product_details_id = @product_details.first.id
  end

  def load_image_url product
    url_for(product.image) if product.image.attached?
  end
end
