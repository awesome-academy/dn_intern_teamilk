class SendEmailChangeStatusOrderJob < ApplicationJob
  queue_as :default

  def perform order
    OrderMailer.check_order_mailer(order).deliver_now
  end
end
