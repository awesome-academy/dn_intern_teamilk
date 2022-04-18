FactoryBot.define do
  factory :product_detail do
    price {40000}
    size {rand(0..2)}
    quantity {rand(10..30)}
    product_id {5}
  end
end
