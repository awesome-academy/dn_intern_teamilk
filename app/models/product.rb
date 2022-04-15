class Product < ApplicationRecord
  has_many :children_items, class_name: Product.name,
            foreign_key: :product_id, dependent: :destroy
  belongs_to :parent_item, class_name: Product.name,
             foreign_key: :product_id, optional: true

  has_many :product_details, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one_attached :image
  validates :image, content_type: {in: Settings.product.image_format,
                                   message: "product.image_wrong_format"},
                    size:         {less_than: Settings.product.size_5.megabytes,
                                   message: "product.image_big_size"}

  scope :parent_products, ->{where(product_id: nil)}
  scope :children_products, ->{where.not(product_id: nil)}
  scope :search_product_by_name, ->(name){where "name LIKE ?", "%#{name}%"}
  scope :search_product_by_parent_id, ->(id){where product_id: id.to_s}
end
