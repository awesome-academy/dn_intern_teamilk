require "rails_helper"
RSpec.describe Address, type: :model do
  describe "Associations" do
    it {should belong_to(:user)}
    it {should have_many(:orders)}
  end

  describe "Scope" do
    let!(:user_1) {FactoryBot.create(:user)}
    let!(:user_2) {FactoryBot.create(:user)}
    let!(:address_1) {FactoryBot.create :address, user_id: user_1.id, default_address: false}
    let!(:address_2) {FactoryBot.create :address, user_id: user_1.id, default_address: true}
    let!(:address_3) {FactoryBot.create :address, user_id: user_2.id, default_address: false}
    it "check scope list address of user" do
      expect(Address.addr_of_user(user_1.id)).to eq([address_1, address_2])
    end

    it "check scope default address of user" do
      expect(Address.default_addr_user).to eq([address_2])
    end

    it "check scope vaild address" do
      expect(Address.valid_addr_user(address_1.id)).to eq([address_1])
    end
  end
end
