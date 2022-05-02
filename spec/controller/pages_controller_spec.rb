require "rails_helper"

RSpec.describe PagesController, type: :controller do
  describe "GET #home" do
    describe "when user not login" do
      it "render home page" do
        get :home
        expect(response).to render_template(:home)
      end
    end

    describe "when login with User account" do
      it "render home page" do
        user = FactoryBot.create(:user)
        sign_in user
        get :home
        expect(response).to render_template(:home)
      end
    end

    describe "when login with admin account" do
      before do
        admin = FactoryBot.create(:user, role: 1)
        sign_in admin
        get :home
      end

      it "display flash welcome admin" do
        expect(flash[:success]).to be == I18n.t("index.hello_admin")
      end

      it "redirect to admin page" do
        expect(response).to redirect_to(admin_path)
      end
    end
  end
end
