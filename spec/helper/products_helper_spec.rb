require "rails_helper"

RSpec.describe ProductsHelper, type: :helper do
  let!(:product1) {FactoryBot.create(:product)}
  let!(:product2) {FactoryBot.create(:product)}
  let!(:detail1) {FactoryBot.create(:product_detail, size: 1, product_id: product1.id)}
  let!(:detail2) {FactoryBot.create(:product_detail, size: 2, product_id: product1.id)}
  let!(:detail3) {FactoryBot.create(:product_detail, size: 0, product_id: product2.id)}

  describe "#load_fisr_product" do
    describe "#load_image_url" do
      it "when product valid" do
        @product = FactoryBot.create(:product)
        @product.image.attach(
              io: File.open(Rails.root.join("app/assets/images/img/img_product", "traSuaFullTHach.png")),
              filename: "traSuaFullTHach.png",
              content_type: "image/png")
        @product.save!
        expect((helper.load_image_url @product).nil?).to be == false
      end

      it "when product valid" do
        @product = FactoryBot.create(:product)
        @product.save!
        expect((helper.load_image_url @product).nil?).to be == true
      end
    end


    describe "use variable @product_details" do
      before :each do
        assign(:product_details, Product.find_by(id: product1.id).product_details.sortSizeAsc)
      end

      describe "#check_product_details?" do
        it "when product_details empty" do
          assign(:product_details, [])
          expect(helper.check_product_details?).to be == false
        end

        it "when product_details empty" do
          expect(helper.check_product_details?).to be == true
        end
      end

      describe "#get_first_size_of_product" do
        it "when product_details empty" do
          assign(:product_details, [])
          expect(helper.get_first_size_of_product).to be == nil
        end

        it "when product_details empty" do
          expect(helper.get_first_size_of_product).to be == detail1
        end
      end

      describe "#get_quantity_status_of_first_size" do
        it "when product_details empty" do
          assign(:product_details, [])
          expect(helper.get_quantity_status_of_first_size).to be == I18n.t("product.out_of_stock")
        end

        it "when product_details empty" do
          expect(helper.get_quantity_status_of_first_size).to be == I18n.t("product.stocking")
        end
      end

      describe "#get_first_price" do
        it "when product_details empty" do
          assign(:product_details, [])
          expect(helper.get_first_price).to be == I18n.t("product.out_of_stock")
        end

        it "when product_details empty" do
          expect(helper.get_first_price).to be == "40.000 VND"
        end
      end
    end
  end
end
