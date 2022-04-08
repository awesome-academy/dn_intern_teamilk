class AddReferenceOrderDetailsProductDetails < ActiveRecord::Migration[6.1]
  def change
    add_reference :order_details, :product_detail, foreign_key: true
  end
end
