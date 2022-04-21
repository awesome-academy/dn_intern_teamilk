require "rails_helper"

RSpec.describe Product, type: :model do
  let!(:category1) {FactoryBot.create(:product, name: "Category1")}
  let!(:category2) {FactoryBot.create(:product, name: "Category2")}
  let!(:product1) {FactoryBot.create(:product, name: "Product1", product_id: category1.id)}
  let!(:product2) {FactoryBot.create(:product, name: "Product2", product_id: category2.id)}

  describe "#relationship" do
    it {should have_many(:children_items)}
    it {should belong_to(:parent_item).optional}
    it {should have_many(:product_details).dependent(:destroy)}
    it {should have_many(:reviews)}
  end

  describe "#validates" do
    describe "attached and validate image" do
      describe "when upload product's image" do
        before :each do
          @product = FactoryBot.create(:product, product_id: category1.id)
        end

        context "with a valid image" do
          it "saves the image" do
            @product.image.attach(
              io: File.open(Rails.root.join("app/assets/images/img/img_product", "traSuaFullTHach.png")),
              filename: "traSuaFullTHach.png",
              content_type: "image/png")
            @product.save!
            expect(@product.image).to be_attached
          end
        end

        context "with an invalid image" do
          it "when image bigger 5MB" do
            @product.image.attach(
              io: File.open(Rails.root.join("app/assets/images/img/", "test_image.jpg")),
              filename: "test_image.jpg",
              content_type: "image/jpg")
            allow(@product).to receive(:save!).and_raise(ActiveRecord::ActiveRecordError,
                                                         I18n.t("product.image_big_size"))
          end

          it "when image wrong format" do
            @product.image.attach(
              io: File.open(Rails.root.join("app/assets/stylesheets", "style.css")),
              filename: "style.css",
              content_type: "image/css")
            allow(@product).to receive(:save!).and_raise(ActiveRecord::ActiveRecordError,
                                                         I18n.t("product.image_wrong_format"))
          end
        end
      end
    end

    describe "validates name" do
      it {should validate_presence_of(:name)}
    end
  end

  describe "#scope" do
    it "parent_products" do
      expect(Product.parent_products).to be == [category1, category2]
    end

    it "children_products" do
      expect(Product.children_products).to be == [product1, product2]
    end

    it "search_product_by_name" do
      expect(Product.search_product_by_name "1").to be == [category1, product1]
    end

    it "search_product_by_parent_id" do
      expect(Product.search_product_by_parent_id category1.id.to_s).to be == [product1]
    end
  end
end
