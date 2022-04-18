require "rails_helper"
RSpec.describe Order, type: :model do
  describe "Associations" do
    it {should belong_to(:user)}
    it {should belong_to(:address)}
    it {should have_many(:order_details)}
  end

  describe "scope" do
  end
end
