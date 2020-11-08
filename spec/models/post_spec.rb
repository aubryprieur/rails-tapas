RSpec.describe Post, type: :model do
  describe "Creation" do
    before do
      @user = FactoryBot.create(:user)
      @post = FactoryBot.create(:post)
    end

    it 'can be created'  do
      expect(@post).to be_valid
    end

    it 'cannot be created without a deadline, title and description' do
      @post.deadline = nil
      @post.title = nil
      @post.description = nil
      expect(@post).to_not be_valid
    end
  end
end

