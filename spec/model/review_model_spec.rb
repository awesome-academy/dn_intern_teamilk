require "rails_helper"
RSpec.describe Review, type: :model do
  describe "Associations" do
    it {should belong_to(:product)}
    it {should belong_to(:user)}
  end
end
