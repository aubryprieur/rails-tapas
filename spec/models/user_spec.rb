RSpec.describe User, type: :model do
  describe "creation" do
    before do
      @user = FactoryBot.create(:user)
    end

    it "Can be created" do
      expect(@user).to be_valid
    end

    it "cannot be created without first_name, last_name" do
      @user.first_name = nil
      @user.last_name = nil
      expect(@user).to_not be_valid
    end

  end
end
