require "rails_helper"

RSpec.describe ProductsController, type: :controller do
  let!(:category1) {FactoryBot.create(:product, name: "Category")}
  let!(:category2) {FactoryBot.create(:product, name: "Category")}
  let!(:category3) {FactoryBot.create(:product, name: "Category")}
  let!(:product1) {FactoryBot.create(:product, product_id: category1.id)}
  let!(:product2) {FactoryBot.create(:product, name: "Product2", product_id: category1.id)}
  let!(:product3) {FactoryBot.create(:product, name: "Product3", product_id: category1.id)}

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

    describe "when load list (childrent) products (Method list_product_final_custom)" do
      describe "when use sort filter list products" do
        describe "when load by cookies (Method get_list_product_by_cookies)" do
          context "load by name (Method get_children_product_by_name)" do
            before :each do
              request.cookies[:id_flag] = 1
              request.cookies[:content_flag] = "Product"
              get :index, params: {sort_id: 2}
            end

            it "load list products successed" do
              expect(assigns(:children_products)).to be
                Product.search_product_by_name("Product").children_products
            end

            it "set value for cookies id_flag after loaded" do
              expect(cookies[:id_flag]).to be == "1"
            end

            it "set value for cookies content_flag after loaded" do
              expect(cookies[:content_flag]).to be == "Product"
            end
          end

          context "load list products by category (Method get_children_product_by_parent_id)" do
            before :each do
              request.cookies[:id_flag] = 2
              request.cookies[:content_flag] = category1.id
              get :index, params: {sort_id: 2}
            end

            it "load list products successed" do
              expect(assigns(:children_products)).to be
              Product.search_product_by_parent_id(category1.id).children_products
            end

            it "set value for cookies id_flag after loaded" do
              expect(cookies[:id_flag]).to be == "2"
            end

            it "set value for cookies content_flag after loaded" do
              expect(cookies[:content_flag]).to be == category1.id.to_s
            end
          end

          context "load list all products (Method get_all_children_product)" do
            it "load list products successed" do
              get :index
              expect(assigns(:children_products)).to be == Product.children_products
            end

            it "delete cookies id_flag after loaded" do
              get :index
              expect(cookies[:id_flag]).to be == nil
            end

            it "delete cookies content_flag after load" do
              get :index
              expect(cookies[:content_flag]).to be == nil
            end
          end
        end

        context "sort list product after loaded (Method list_product_after_filter)" do
          it "sort by name asc" do
            get :index, params: {sort_id: 1}
            expect(assigns(:children_products)).to be
              Product.children_products.order(:name)
          end

          it "sort by name desc" do
            get :index, params: {sort_id: 2}
            expect(assigns(:children_products)).to be
              Product.children_products.order(name: :desc)
          end

          it "sort by date update asc" do
            get :index, params: {sort_id: 3}
            expect(assigns(:children_products)).to be
              Product.children_products.order(:updated_at)
          end

          it "sort by date update desc" do
            get :index, params: {sort_id: 4}
            expect(assigns(:children_products)).to be
              Product.children_products.order(updated_at: :desc)
          end
        end
      end

      describe "when load list (childrent) products by params (Method get_list_product_by_params)" do

        context "when search products (Method get_children_product_by_name)" do
          before :each do
            get :index, params: {name: "Product"}
          end

          it "load list product by search successed" do
            expect(assigns(:children_products)).to be ==
              Product.search_product_by_name("Product").children_products
          end

          it "set value for cookies id_flag after loaded" do
            expect(cookies[:id_flag]).to be == "1"
          end

          it "set value for cookies content_flag after loaded" do
            expect(cookies[:content_flag]).to be == "Product"
          end
        end

        context "load list products by category (Method get_children_product_by_parent_id)" do
          before :each do
            get :index, params: {parent_id: category1.id}
          end

          it "load list product by category successed" do
            expect(assigns(:children_products)).to be ==
              Product.search_product_by_parent_id(category1.id).children_products
          end

          it "set value for cookies id_flag after loaded" do
            expect(cookies[:id_flag]).to be == "2"
          end

          it "set value for cookies content_flag after loaded" do
            expect(cookies[:content_flag]).to be == category1.id.to_s
          end
        end

        context "load list all products (Method get_all_children_product)" do
          before :each do
            get :index
          end
          it "load list all product successed" do
            expect(assigns(:children_products)).to be == Product.children_products
          end

          it "delete cookies id_flag after loaded" do
            expect(cookies[:id_flag]).to be == nil
          end

          it "delete cookies content_flag after loaded" do
            expect(cookies[:content_flag]).to be == nil
          end
        end
      end

      describe "when can not found list products" do
        it "display flash can not found" do
          Product.where.not(product_id: nil).find_each(&:destroy)
          get :index
          expect(flash[:danger]).to be == I18n.t("product.children_product_not_found")
        end
      end
    end
  end

  describe "POST #create" do
    context "when create product successed" do
      it "display flash successed" do
        post :create, params: {product: {name: "Test1", description: nil, product_id: nil}}
        expect(flash[:success]).to be == I18n.t("admin.products.add_success")
      end

      it "add new products into database" do
        count_product = Product.count
        post :create, params: {product: {name: "Test1", description: nil, product_id: nil}}
        expect(count_product + 1).to be == Product.count
        expect(assigns(:product)).to be == Product.last
      end
    end

    context "when create failed" do
      it "display flash failed" do
        post :create, params: {product: {name: "", description: nil, product_id: nil}}
        expect(flash[:danger]).to be == I18n.t("admin.products.add_faild")
      end
    end

    context "redirect after create" do
      it "add product and rediect to admin category" do
        post :create, params: {product: {name: "Test1", description: nil, product_id: nil}}
        expect(response).to redirect_to(admin_categories_path)
      end

      it "ad category and rediect to admin product" do
        post :create, params: {product: {name: "Test1", description: nil, product_id: category1.id}}
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
    context "when delete successed" do
      it "display flash successed" do
        delete :destroy, params: {id: product1.id}
        expect(flash[:success]).to be == I18n.t("admin.products.product_del_success")
      end

      it "delete from databases" do
        count_product = Product.count
        delete :destroy, params: {id: product1.id}
        expect(count_product - 1).to be == Product.count
        expect(Product.find_by id: product1.id).to be == nil
      end
    end

    context "when delete failed" do
      it "display flash failed" do
        allow(Product).to receive(:find_by).and_return(product1)
        allow(product1).to receive(:destroy).and_return(false)
        delete :destroy, params: {id: product1.id}
        expect(flash[:danger]).to be == I18n.t("admin.products.product_del_failed")
      end
    end

    context "redirect after delete" do
      it "delete category and rediect to admin category" do
        delete :destroy, params: {id: category3.id}
        expect(response).to redirect_to(admin_categories_path)
      end

      it "delete product and rediect to admin product" do
        delete :destroy, params: {id: product1.id}
        expect(response).to redirect_to(admin_products_path)
      end
    end
  end
end
