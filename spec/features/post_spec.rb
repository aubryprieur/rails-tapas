require 'rails_helper'

describe 'navigate' do
  before do
    @user = User.create(email: "test@test.com", password: "azerty", password_confirmation: "azerty", first_name: "Jon", last_name: "Snow")
    login_as(@user, :scope => :user)
  end

  describe 'index' do
    before do
      visit posts_path
    end

    it 'can be reached successfully' do
      expect(page.status_code).to eq(200)
    end

    it 'has a title of Posts' do
      expect(page).to have_content(/Liste des appels d'offres/)
    end

    it 'has a list of posts' do
      post1 = Post.create(deadline: Date.today, title: "Appel d'offres 1", description: "Description1", user_id: @user.id)
      post2 = Post.create(deadline: Date.today, title: "Appel d'offres 2", description: "Description 2", user_id: @user.id)
      visit posts_path
      expect(page).to have_content(/Description1|Description 2|Appel d'offres 1|Appel d'offres 2/)
    end
  end

  describe 'creation' do
    before do
      visit new_post_path
    end

    it 'has a new form that can be reached' do
      expect(page.status_code).to eq(200)
    end

    it 'can be created from new form page' do
      fill_in 'post[deadline]', with: Date.today
      fill_in 'post[title]', with: "Un titre"
      fill_in 'post[description]', with: "Une description"

      click_on "Save"

      expect(page).to have_content("Un titre")
    end

    it 'will have a user associated it' do
      fill_in 'post[deadline]', with: Date.today
      fill_in 'post[title]', with: "User title"
      fill_in 'post[description]', with: "User description"
      click_on "Save"

      expect(User.last.posts.last.title).to eq("User title")
    end


  end
end

