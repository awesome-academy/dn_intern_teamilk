class ProductDetail < ApplicationRecord
  has_many :order_details, dependent: :destroy
  belongs_to :product
  delegate :name, to: :product, prefix: :product

  enum size: {M: 0, L: 1, XL: 2}

  scope :sortSizeAsc, ->{order :size}
  scope :product_by_id, ->(id){where product_id: id}
end
