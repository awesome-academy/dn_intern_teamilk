require "rails_helper"

RSpec.describe Admin::BaseController, type: :controller do
  let!(:admin1) {FactoryBot.create(:user, role: 1)}
  let!(:user1) {FactoryBot.create(:user)}

  describe "GET #index" do
    describe "when check login" do
      describe "when user login" do
        context "user logged in" do
          it "load current_user" do
            get :index, session: {user_id: user1.id}
            expect(assigns(:current_user)) == user1
          end
        end

        context "user not log in" do
          it "display flash not log in" do
            get :index
            expect(flash[:danger]).to be == I18n.t("admin_index.not_logged_in")
          end

          it "go to home page" do
            get :index
            expect(response).to redirect_to(root_path)
          end
        end
      end

      describe "when admin login" do
        context "admin logged" do
          it "check admin role" do
            get :index, session: {user_id: admin1.id}
            expect(assigns(:current_user).admin?).to be == true
          end
        end

        context "logged but not admin" do
          before :each do
            get :index, session: {user_id: user1.id}
          end
          it "display flag can not access" do
            expect(flash[:danger]).to be == I18n.t("admin_index.can_not_accesss")
          end

          it "go to home page" do
            expect(response).to redirect_to(root_path)
          end
        end
      end
    end
  end
end
