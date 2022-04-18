require 'rails_helper'
include SessionsHelper
include CartsHelper
RSpec.describe OrdersController, type: :controller do
  let!(:user) {FactoryBot.create(:user)}
  let!(:address) {FactoryBot.create :address, user_id: user.id}
  let!(:order) {FactoryBot.create :order, user_id: user.id, address_id: address.id}
  let!(:category) {FactoryBot.create :product, name: "Category"}
  let!(:product_1) {FactoryBot.create :product, name: "Product 1", product_id: category.id}
  let!(:product_2) {FactoryBot.create :product, name: "Product 2", product_id: category.id}
  let!(:product_3) {FactoryBot.create :product, name: "Product 3", product_id: category.id}
  let!(:product_detail_1) {FactoryBot.create :product_detail, product_id: product_1.id}
  let!(:product_detail_2) {FactoryBot.create :product_detail, product_id: product_2.id}
  let!(:product_detail_3) {FactoryBot.create :product_detail, product_id: product_3.id}

  describe "GET #index" do
    it_behaves_like "not logged for get method", "index"

    context "when has login" do
      before do
        log_in user
        get :index
      end

      it "check data return" do
        expect(assigns(:orders)).to eq([order])
      end
      it "render index page" do
        expect(response).to render_template :index
      end
    end
  end

  describe "GET #new" do
    it_behaves_like "not logged for get method", "new"

    context "when has login" do
      before do
        log_in user
        get :new
        session[:carts] = {}
      end

      it "check default address" do
        expect(assigns(:default_address)).to eq(address)
      end

      context "when current cart empty" do
        it "flash danger" do
          expect(flash[:danger]).to eq I18n.t("orders.new.no_proc_in_cart")
        end

        it "redirect to cart page" do
          expect(response).to redirect_to cart_url
        end
      end

      context "when current cart is not empty" do
        before do
          session[:carts] = {product_detail_1.id => 3, product_detail_2.id => 4}
          get :new
        end

        it "render new pages" do
          expect(response).to render_template :new
        end

        it "check data product return" do
          expect(assigns(:products)).to eq({product_detail_1 => 3, product_detail_2 => 4})
        end
      end

      context "when product in cart not found" do
        before do
          session[:carts] = {product_detail_1.id => 3, -1 => 4, product_detail_2.id => 4}
          get :new
        end

        it "flash danger" do
          expect(flash[:danger]).to eq I18n.t("product.out_of_stock")
        end

        it "redirect to cart page" do
          expect(response).to redirect_to cart_path
        end

        it "delete product from cart" do
          expect(assigns(:products)).to eq(product_detail_1 => 3, product_detail_2 => 4)
        end
      end
    end
  end

  describe "POST #create" do
    it_behaves_like "not logged for other method" do
      before do
        post :create, params: {address_id: address.id}
      end
    end

    context "when has login" do
      before do
        log_in user
        session[:carts] = {product_detail_1.id => 2, product_detail_2.id => 2, product_detail_3.id => -12}
        post :create, params: {address_id: address.id}
      end
      it "check data new_order" do
        expect(assigns(:new_order)).to eq(current_user.orders.last)
      end

      it "redirect home pages" do
        expect(response).to redirect_to root_url
      end

      it "flash success" do
        expect(flash[:success]).to eq I18n.t("orders.create.success_order")
      end
    end

    context "when save error raise exception" do
      before do
        allow_any_instance_of(Order).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)

        log_in user
        post :create, params: {address_id: address.id}
        session[:carts] = {product_detail_1.id => 2, product_detail_2.id => 2, product_detail_3.id => -12}
      end
      it "flash danger" do
        expect(flash[:danger]).to eq I18n.t("orders.create.has_err")
      end

      it "redirect new order pages" do
        expect(response).to redirect_to new_order_url
      end
    end
  end

  describe "GET #show_by_status" do
    let!(:order_1) {FactoryBot.create :order, user_id: user.id, address_id: address.id, status: 0}
    let!(:order_2) {FactoryBot.create :order, user_id: user.id, address_id: address.id, status: 2}
    let!(:order_3) {FactoryBot.create :order, user_id: user.id, address_id: address.id, status: 2}

    it_behaves_like "not logged for other method" do
      before do
        get :show_by_status, params: {id_status: 0}
      end
    end

    context "when has login" do
      before do
        log_in user
        get :show_by_status, params: {id_status: 2}
      end

      it "check data return" do
        expect(assigns(:orders)).to eq([order_3, order_2])
      end
      it "render index page" do
        expect(response).to render_template :index
      end
    end
  end

  describe "PUT #update" do
    let!(:order_1) {FactoryBot.create :order, user_id: user.id, address_id: address.id, status: 4}
    let!(:order_2) {FactoryBot.create :order, user_id: user.id, address_id: address.id, status: 4}


    it_behaves_like "not logged for other method" do
      before do
        put :update, params: {address_id: address.id, id: order_1.id}
      end
    end

    context "when has login" do
      before do
        log_in user
      end
      context "find order by id" do
        before do
          put :update, params: {address_id: address.id, id: order_1.id}
        end
        it "check data order" do
          expect(assigns(:order)).to eq(order_1)
        end

        it "redirect orders pages" do
          expect(response).to redirect_to orders_url
        end

        it "flash success" do
          expect(flash[:success]).to eq I18n.t("orders.create.sucess_order_status")
        end
      end

      context "not found order by id" do
        before do
          put :update, params: {address_id: address.id, id: -1}
        end

        it "flash danger" do
          expect(flash[:danger]).to eq I18n.t("carts.create.not_found_product")
        end

        it "redirect cart pages" do
          expect(response).to redirect_to cart_path
        end
      end

      context "when update error raise exception" do
        before do
          allow_any_instance_of(Order).to receive(:update!).and_raise(NoMethodError)

          put :update, params: {address_id: address.id, id: order_1.id}
        end
        it "flash danger" do
          expect(flash[:danger]).to eq I18n.t("orders.create.has_err")
        end

        it "redirect order pages" do
          expect(response).to redirect_to orders_url
        end
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:order_1) {FactoryBot.create :order, user_id: user.id, address_id: address.id, status: 0}

    it_behaves_like "not logged for other method" do
      before do
        delete :destroy, params: {address_id: address.id, id: order_1.id}
      end
    end

    context "when has login" do
      before do
        log_in user
      end

      context "find order by id" do
        before do
          delete :destroy, params: {address_id: address.id, id: order_1.id}
        end
        it "check data order" do
          order_1.status = 5
          expect(assigns(:order)).to eq(order_1)
        end

        it "redirect orders pages" do
          expect(response).to redirect_to orders_url
        end

        it "flash success" do
          expect(flash[:success]).to eq I18n.t("orders.destroy.success_order")
        end
      end

      context "not found order by id" do
        before do
          delete :destroy, params: {address_id: address.id, id: -1}
        end

        it "flash danger" do
          expect(flash[:danger]).to eq I18n.t("carts.create.not_found_product")
        end

        it "redirect cart pages" do
          expect(response).to redirect_to cart_path
        end
      end

      context "when update error raise exception" do
        before do
          allow_any_instance_of(Order).to receive(:update!).and_raise(NoMethodError)

          delete :destroy, params: {address_id: address.id, id: order_1.id}
        end
        it "flash danger" do
          expect(flash[:danger]).to eq I18n.t("orders.destroy.has_err")
        end

        it "redirect order pages" do
          expect(response).to redirect_to orders_url
        end
      end
    end
  end
end
