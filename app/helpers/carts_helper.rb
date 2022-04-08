module CartsHelper
  def cart_current
    session[:carts] ||= {}
  end

  def caculator_price_in_cart price, quantity
    price * quantity
  end

  def load_image_path_product product_id
    "img/img_product/" + Product.find_by(id: product_id).image
  end

  def cart_total_price_in_cart
    cart_current.reduce(0) do |total, element|
      product_detail = find_product_detail_in_cart(element[0])
      total + (product_detail.price * element[1])
    end
  end

  def find_product_detail_in_cart id
    product_detail = ProductDetail.find_by id: id
    return product_detail if product_detail

    flash[:danger] = t "product.product_not_found"
    delete_cart id
  end

  def delete_cart product_detail_id
    return unless cart_current.key?(product_detail_id)

    cart_current.delete(product_detail_id)
  end
end
