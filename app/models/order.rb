class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address

  has_many :order_details, dependent: :destroy

  enum status: {waiting: 0, making: 1, delivering: 2,
                delivered: 3, success: 4, rejected: 5}
end
