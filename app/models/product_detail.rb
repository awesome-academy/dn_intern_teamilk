class ProductDetail < ApplicationRecord
  belongs_to :product
  delegate :name, to: :product, prefix: :product

  enum size: {size_m: 0, size_l: 1, size_xl: 2}
end
