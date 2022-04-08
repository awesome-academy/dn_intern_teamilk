class Address < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :destroy

  scope :addr_of_user, ->(id){where user_id: id}
  scope :default_addr_user, ->{where default_address: true}
  scope :valid_addr_user, ->(id){where id: id}
end
