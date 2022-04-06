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
end
