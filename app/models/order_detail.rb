class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product_detail

  validates :quantity, presence: true
  validates :price, presence: true

  after_save :update_quantiy_product_details

  private

  def update_quantiy_product_details
    if order.waiting?
      product_detail.quantity = product_detail.quantity - quantity
    end
    product_detail.save
  end
end
