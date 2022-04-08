# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# User.create(name: "Hoang Truong", email: "hat@gmail.com",
#             password: "123456", password_confirmation: "123456",
#             activated: true, activated_at: Time.zone.now)
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

# Address.create(
#   name: "Hoài Thương",
#   address: "13F, Keangnam Hanoi Landmark Tower, Pham Hung, Nam Tu Liem, Hanoi",
#   phone: "0123456789",
#   default_address: true,
#   user_id: 1
# )

# Address.create(
#   name: "Hoài Nhớ",
#   address: "4F, FHome Building, 16 Ly Thuong Kiet Str., Hai Chau district, Da Nang",
#   phone: "0123456789",
#   default_address: false,
#   user_id: 1
# )

# User.create(name: "Khach quen", email: "kq1@gmail.com",
#             password: "123456", password_confirmation: "123456",
#             activated: true, activated_at: Time.zone.now)

# User.create(name: "Super Admin", email: "admin@gmail.com",
#             password: "123456", password_confirmation: "123456",
#             activated: true, role: 1, activated_at: Time.zone.now)
User.create(name: "Adam Kaid", email: "kais@gmail.com",
            password: "123456", password_confirmation: "123456",
            activated: true, activated_at: Time.zone.now)
