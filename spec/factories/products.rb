FactoryBot.define do
  factory :product do
    name {Faker::Name.name}
    description {"description"}
  end
end
