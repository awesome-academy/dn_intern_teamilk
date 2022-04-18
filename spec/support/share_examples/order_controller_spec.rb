RSpec.shared_examples "not logged for get method" do |action|
  context "when no login" do
    before do
      get action
    end
    it "redirect login page"do
      expect(response).to redirect_to login_path
    end

    it "show flag danger" do
      expect(flash[:danger]).to eq I18n.t("carts.needs_login")
    end
  end
end

RSpec.shared_examples "not logged for other method" do
  context "when no login" do
    it "redirect login page"do
      expect(response).to redirect_to login_path
    end

    it "show flag danger" do
      expect(flash[:danger]).to eq I18n.t("carts.needs_login")
    end
  end
end
