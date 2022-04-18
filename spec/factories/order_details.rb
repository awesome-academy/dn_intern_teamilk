FactoryBot.define do
  factory :order_detail do
    quantity {1}
    price {1}
    order_id {1}
    product_detail_id {1}
  end
end
