class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address

  delegate :name, to: :address, prefix: :address

  has_many :order_details, dependent: :destroy

  enum status: {waiting: 0, making: 1, delivering: 2,
                delivered: 3, success: 4, rejected: 5}

  scope :list_orders_of_user, ->(id){where user_id: id}
  scope :sort_by_day, ->{order(created_at: :desc)}
  scope :show_by_status, ->(id_status){where status: id_status}
end
