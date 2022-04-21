require "rails_helper"

RSpec.describe ProductDetail, type: :model do
  let!(:product1) {FactoryBot.create(:product)}
  let!(:product2) {FactoryBot.create(:product)}
  let!(:detail1) {FactoryBot.create(:product_detail, size: 1, product_id: product1.id)}
  let!(:detail2) {FactoryBot.create(:product_detail, size: 2, product_id: product1.id)}
  let!(:detail3) {FactoryBot.create(:product_detail, size: 0, product_id: product2.id)}

  describe "#relationship" do
    it {should have_many(:order_details).dependent(:destroy)}
    it {should belong_to(:product)}
    it {should delegate_method(:product_name).to(:product).as(:name).with_prefix(:product)}
  end

  describe "#enum" do
    it { should define_enum_for(:size).with_values({:M=>0, :L=>1, :XL=>2}) }
  end

  describe "#scope" do
    it "sortSizeAsc" do
      expect(ProductDetail.sortSizeAsc).to eq([detail3, detail1, detail2])
    end

    it "product_by_id" do
      expect(ProductDetail.product_by_id product1.id).to eq([detail1, detail2])
    end
  end
end
