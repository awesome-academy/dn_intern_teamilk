module OrdersHelper
  def order_params_address
    current_addr = Address.addr_of_user(params[:user_id])
                          .valid_addr_user(params[:address_id])
    return true unless current_addr.empty?

    flash[:danger] = t ".has_err"
    redirect_to new_order_url
  end

  def caculator_price_in_order order
    order.order_details.sum("price * quantity")
  end
end
