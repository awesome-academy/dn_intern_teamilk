FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    phone {"01233444444"}
    role {0}
    password {"qwerty"}
    password_confirmation {"qwerty"}
    confirmed_at {Time.now}
  end
end
