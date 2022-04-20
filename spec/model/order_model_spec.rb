require "rails_helper"
RSpec.describe Order, type: :model do
  describe "Associations" do
    it {should belong_to(:user)}
    it {should belong_to(:address)}
    it {should have_many(:order_details)}
  end

  describe "Scope" do
    let!(:user) {FactoryBot.create(:user)}
    let!(:address) {FactoryBot.create :address, user_id: user.id}
    let!(:order_1) {FactoryBot.create :order, user_id: user.id, address_id: address.id, status: 0}
    let!(:order_2) {FactoryBot.create :order, user_id: user.id, address_id: address.id, status: 2}
    let!(:order_3) {FactoryBot.create :order, user_id: user.id, address_id: address.id, status: 2}
    let!(:user_2) {FactoryBot.create(:user)}
    let!(:address_2) {FactoryBot.create :address, user_id: user_2.id}
    let!(:order_4) {FactoryBot.create :order, user_id: user_2.id, address_id: address_2.id, status: 0}
    let!(:order_5) {FactoryBot.create :order, user_id: user_2.id, address_id: address_2.id, status: 2}
    it "check scope sort by day" do
      expect(Order.sort_by_day).to eq([order_5, order_4, order_3, order_2, order_1])
    end

    it "check scope list order of user" do
      expect(Order.list_orders_of_user(user_2.id)).to eq([order_4, order_5])
    end

    it "check scope show by status" do
      expect(Order.show_by_status(2)).to eq([order_2, order_3, order_5])
    end
  end

  describe "Delegate" do
    it { should delegate_method(:name).to(:address).with_prefix(:address) }
  end
end
