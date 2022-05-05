require "rails_helper"

RSpec.describe ProductsController, type: :controller do
  let!(:category1) {FactoryBot.create(:product, name: "Category")}
  let!(:category2) {FactoryBot.create(:product, name: "Category")}
  let!(:category3) {FactoryBot.create(:product, name: "Category")}
  let!(:product1) {FactoryBot.create(:product, name: "Tra sua", product_id: category1.id)}
  let!(:product2) {FactoryBot.create(:product, name: "Product2", product_id: category2.id)}
  let!(:product3) {FactoryBot.create(:product, name: "Product3", product_id: category1.id)}
  let!(:admin) {FactoryBot.create(:user, role: 1)}

  describe "GET #index" do
    it "load template index" do
      get :index
      expect(response).to render_template(:index)
    end

    context "when can not find load list Catogaries (Method get_parent_products)" do
      before :each do
        Product.where(product_id: nil).find_each(&:destroy)
      end

      it "display flash not found categories" do
        get :index
        expect(flash[:danger]).to be == I18n.t("product.parent_product_not_found")
      end

      it "rediect to homepage" do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end

    context "filter products" do
      it "when search" do
        get :index, params:{q:{"name_cont"=>"Product"}}
        expect(assigns(:children_products)).to eq([product3, product2])
      end

      it "when click category" do
        get :index, params:{q:{"product_id_eq"=>category2.id}}
        expect(assigns(:children_products)).to eq([product2])
      end

      it "when sort list products by name" do
        get :index, params:{q:{"s"=>"name asc"}}
        expect(assigns(:children_products)).to eq([product2, product3, product1])
      end

      it "when sort list products by update" do
        get :index, params:{q:{"s"=>"update_at asc"}}
        expect(assigns(:children_products)).to eq([product1, product3, product2])
      end
    end
  end

  describe "POST #create" do
    before :each do
      sign_in admin
    end

    context "when create product successed" do
      it "display flash successed" do
        post :create, params: {product: {name: "Test1", description: nil, product_id: nil}}
        expect(flash[:success]).to be == I18n.t("admin.products.add_success")
      end

      it "add new products into database" do
        count_product = Product.count
        post :create, params: {product: {name: "Test1", description: nil, product_id: nil}},
                      session: {user_id: admin.id}
        expect(count_product + 1).to be == Product.count
        expect(assigns(:product)).to be == Product.last
      end
    end

    context "when create failed" do
      it "display flash failed" do
        post :create, params: {product: {name: "", description: nil, product_id: nil}},
                      session: {user_id: admin.id}
        expect(flash[:danger]).to be == I18n.t("admin.products.add_faild")
      end
    end

    context "redirect after create" do
      it "add product and rediect to admin category" do
        post :create, params: {product: {name: "Test1", description: nil, product_id: nil}},
                      session: {user_id: admin.id}
        expect(response).to redirect_to(admin_categories_path)
      end

      it "add category and rediect to admin product" do
        post :create, params: {product: {name: "Test1", description: nil, product_id: category1.id}},
                      session: {user_id: admin.id}
        expect(response).to redirect_to(admin_products_path)
      end
    end
  end

  describe "GET #show" do
    it "load template product detail" do
      get :show, params: {id: product1.id}
      expect(response).to render_template(:show)
    end

    context "when can not load products (Method find_product)" do
      before :each do
        get :show, params: {id: -1}
      end

      it "display flash not found" do
        expect(flash[:danger]).to be == I18n.t("product.product_not_found")
      end

      it "rediect to homepage" do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      sign_in admin
    end

    context "when delete successed" do
      it "display flash successed" do
        delete :destroy, params: {id: product1.id}, session: {user_id: admin.id}
        expect(flash[:success]).to be == I18n.t("admin.products.product_del_success")
      end

      it "delete from databases" do
        count_product = Product.count
        delete :destroy, params: {id: product1.id}, session: {user_id: admin.id}
        expect(count_product - 1).to be == Product.count
        expect(Product.find_by id: product1.id).to be == nil
      end
    end

    context "when delete failed" do
      it "display flash failed" do
        allow(Product).to receive(:find_by).and_return(product1)
        allow(product1).to receive(:destroy).and_return(false)
        delete :destroy, params: {id: product1.id}, session: {user_id: admin.id}
        expect(flash[:danger]).to be == I18n.t("admin.products.product_del_failed")
      end
    end

    context "redirect after delete" do
      it "delete category and rediect to admin category" do
        delete :destroy, params: {id: category3.id}, session: {user_id: admin.id}
        expect(response).to redirect_to(admin_categories_path)
      end

      it "delete product and rediect to admin product" do
        delete :destroy, params: {id: product1.id}, session: {user_id: admin.id}
        expect(response).to redirect_to(admin_products_path)
      end
    end
  end
end
