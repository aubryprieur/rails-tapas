RSpec.describe Post, type: :model do
  describe "Creation" do
    before do
      user = User.create(email: "test@test.com", password: "azerty", password_confirmation: "azerty", first_name: "Jon", last_name: "Snow")
      login_as(user, :scope => :user)
      @post = Post.create(deadline: Date.today, title: "titre de l'appel d'offre", description: "description du marché", user_id: user.id)
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

