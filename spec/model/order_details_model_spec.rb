require "rails_helper"
RSpec.describe OrderDetail, type: :model do
  describe "Associations" do
    it {should belong_to(:order)}
    it {should belong_to(:product_detail)}
  end

  describe "Validation" do
    it {is_expected.to validate_presence_of :quantity}
    it {is_expected.to validate_presence_of :price}
  end

  describe "Check after save" do
    let!(:user) {FactoryBot.create(:user)}
    let!(:address) {FactoryBot.create :address, user_id: user.id}
    let!(:product) {FactoryBot.create :product}
    let!(:product_detail) {FactoryBot.create :product_detail, price: 20000, size: 1,
                                                              quantity: 10, product_id: product.id}
    let!(:order) {FactoryBot.create :order, user_id: user.id, address_id: address.id, status: 0}



    context "Save order details" do
      let!(:order_detail) {FactoryBot.create :order_detail, quantity: 2, price: 20000,
                                                         order_id: order.id,
                                                         product_detail_id: product_detail.id}
      it "change quantity of product" do
        expect(order_detail.product_detail.quantity).to eq(8)
      end
    end


  end
end
