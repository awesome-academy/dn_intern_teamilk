class Admin::OrdersController < Admin::BaseController
  before_action :find_order_by_id, only: %i(update show)

  def index
    @q = Order.ransack(params[:q])
    @orders = @q.result.sort_by_day
  end

  def admin_show_by_status
    @orders = Order.show_by_status(params[:id_status]).sort_by_day
    render "index"
  end

  def update
    if valid_status? params[:order][:status]
      ActiveRecord::Base.transaction do
        @order.update!(params_update_order)
      end
      send_email_change_status @order
      flash[:success] = t "orders.create.chage_order_success"
    else
      flash[:danger] = t "orders.create.has_errss"
    end
    redirect_to admin_orders_path
  rescue NoMethodError
    flash[:danger] = t "orders.create.has_err"
    redirect_to admin_orders_path
  end

  def show; end

  private

  def params_update_order
    params.require(:order).permit(:status)
  end

  def valid_status? status
    Order.statuses.include? status
  end

  def find_order_by_id
    @order = Order.find_by id: params[:id]
    return @order if @order

    flash[:danger] = t("carts.create.not_found_product")
    redirect_to admin_orders_path
  end

  def send_email_change_status order
    SendEmailChangeStatusOrderJob.set(wait: Settings.number.digits_1.minutes)
                                 .perform_later order
  end
end
