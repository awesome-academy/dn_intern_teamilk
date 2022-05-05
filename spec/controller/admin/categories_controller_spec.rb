require "rails_helper"

RSpec.describe Admin::CategoriesController, type: :controller do
  let!(:admin1) {FactoryBot.create(:user, role: 1)}
  let!(:user1) {FactoryBot.create(:user)}
  let!(:category1) {FactoryBot.create(:product, name: "Category")}
  let!(:category2) {FactoryBot.create(:product, name: "Category")}

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

      it "loaded list categories" do
        expect(assigns(:pagy_parent_products)).to eq([category1,category2])
      end
    end

    describe "load search categories" do
      context "when list categories was founded" do
        before :each do
          sign_in admin1
          get :index, params:{name: "Category"}
        end

        it "when setting list_product" do
          expect(assigns(:list_product)).to eq([category1,category2])
        end
      end

      context "when list categories can not find" do
        it "display flag not found" do
          Product.find_each(&:destroy)
          sign_in admin1
          get :index, params:{name: "Category"}
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
