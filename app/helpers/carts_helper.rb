module CartsHelper
  def cart_current
    session[:carts] ||= {}
  end

  def caculator_price_in_cart price, quantity
    price * quantity
  end
end
