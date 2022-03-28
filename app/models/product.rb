class Product < ApplicationRecord
  has_many :children_items, class_name: Product.name,
            foreign_key: :product_id, dependent: :destroy
  belongs_to :parent_item, class_name: Product.name,
             foreign_key: :product_id, optional: true

  has_many :product_details, dependent: :destroy
  has_many :reviews, dependent: :destroy
end
