require "rails_helper"

RSpec.describe Admin::ProductsController, type: :controller do
  let!(:admin1) {FactoryBot.create(:user, role: 1)}
  let!(:user1) {FactoryBot.create(:user)}
  let!(:category1) {FactoryBot.create(:product, name: "Category")}
  let!(:category2) {FactoryBot.create(:product, name: "Category")}
  let!(:product1) {FactoryBot.create(:product, name: "Product", product_id: category1.id)}
  let!(:product2) {FactoryBot.create(:product, product_id: category1.id)}
  let!(:product3) {FactoryBot.create(:product, name: "Product", product_id: category2.id)}

  describe "GET #index" do
    describe "load default template" do
      before :each do
        @list_product = Product.all
        sign_in admin1
        get :index
      end

      it "load teamplate" do
        expect(response).to render_template(:index)
      end

      it "loaded list products" do
        expect(assigns(:pagy_children_products)).to eq([product1,product2,product3])
      end

      it "loaded list products" do
        expect(assigns(:pagy_children_products)).to eq([product1,product2,product3])
      end
    end

    describe "load search product" do
      context "when list products was founded" do
        before :each do
          sign_in admin1
          get :index, params:{name: "Product"}
        end

        it "when setting cookies" do
          expect(cookies[:id_flag]).to be == "1"
          expect(cookies[:content_flag]).to be == "Product"
        end

        it "when setting list_product" do
          expect(assigns(:list_product)).to eq([product1,product3])
        end
      end

      context "when list products can not find" do
        it "display flag not found" do
          Product.find_each(&:destroy)
          sign_in admin1
          get :index, params:{name: "Product"}
          expect(flash.now[:warning]).to be == I18n.t("admin.not_found")
        end
      end
    end
  end

  describe "GET #create" do
    it "load teamplate" do
      sign_in admin1
      get :create
      expect(response).to render_template(:create)
    end
  end
end
