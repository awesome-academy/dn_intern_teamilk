module ProductsHelper
  def load_image_url product
    url_for(product.image) if product.image.attached?
  end

  def check_product_details?
    return false if @product_details.empty?

    @load_first = get_first_size_of_product
    @load_first.present? && @load_first.quantity.positive?
  end

  def get_first_size_of_product
    return @product_details.first if @product_details.present?
  end

  def get_quantity_status_of_first_size
    @load_first = get_first_size_of_product
    if @product_details.present? && @load_first.quantity.positive?
      t "product.stocking"
    else
      t "product.out_of_stock"
    end
  end

  def get_first_price
    @load_first = get_first_size_of_product
    if @load_first.nil?
      t "product.out_of_stock"
    else
      number_to_currency(@product_details.first.price, unit: "").to_s + "VND"
    end
  end
end
