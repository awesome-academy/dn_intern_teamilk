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
        get :index, session: {user_id: admin1.id}
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
          get :index, session: {user_id: admin1.id}, params:{name: "Category"}
        end

        it "when setting cookies" do
          expect(cookies[:id_flag]).to be == "1"
          expect(cookies[:content_flag]).to be == "Category"
        end

        it "when setting list_product" do
          expect(assigns(:list_product)).to eq([category1,category2])
        end
      end

      context "when list categories can not find" do
        it "display flag not found" do
          Product.find_each(&:destroy)
          get :index, session: {user_id: admin1.id}, params:{name: "Category"}
          expect(flash.now[:warning]).to be == I18n.t("admin.not_found")
        end
      end
    end
  end

  describe "GET #create" do
    it "load teamplate" do
      get :create, session: {user_id: admin1.id}
      expect(response).to render_template(:create)
    end
  end
end
