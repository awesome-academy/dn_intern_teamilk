# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(name: "Hoang Truong", email: "hat@gmail.com",
            password: "123456", password_confirmation: "123456",
            activated: true, activated_at: Time.zone.now)
# Product.create(name: "Tra sua", description: "Tra sua danh muc")
# 10.times do
#   Product.create(name: Faker::Nation.capital_city,
#                   description: Faker::Lorem.sentence(),
#                   image: "traSuaFullTHach.png",
#                   product_id: 1)
# end

# 30.times do |n|
#   ProductDetail.create(quantity: n,
#                        price: n*10000,
#                        size: 1,
#                        product_id: Product.pluck(:id).sample)
# end
