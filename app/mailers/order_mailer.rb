class OrderMailer < ApplicationMailer
  def check_order_mailer order
    @order = order
    mail(to: @order.user_email,
         subject: t("enums.order_status.#{@order.status}"))
  end
end
