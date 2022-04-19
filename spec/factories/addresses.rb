FactoryBot.define do
  factory :address do
    name {Faker::Name.name}
    address {"sdsadas"}
    phone {"0871116262"}
    user_id {1}
  end
end
