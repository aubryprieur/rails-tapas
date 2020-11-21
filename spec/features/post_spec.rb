require 'rails_helper'

describe 'navigate' do
  before do
    @user = FactoryBot.create(:user)
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
      post1 = FactoryBot.create(:post)
      post2 = FactoryBot.create(:second_post)

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
      fill_in 'post[client]', with: "Un client"
      fill_in 'post[title]', with: "Un titre"
      fill_in 'post[rich_body]', with: "Une description"

      click_on "Enregistrer"

      expect(page).to have_content("Un titre")
    end

    it 'will have a user associated it' do
      fill_in 'post[deadline]', with: Date.today
      fill_in 'post[client]', with: "Un client"
      fill_in 'post[title]', with: "User title"
      fill_in 'post[rich_body]', with: "User description"
      click_on "Enregistrer"

      expect(User.last.posts.last.title).to eq("User title")
    end
  end
  describe 'edit' do
    before do
      post = FactoryBot.create(:post)
      visit post_path(post[:id])
    end

    it 'can be reached by clicking edit on index page' do
      click_on 'Edit'
      expect(page.status_code).to eq(200)
    end

    it 'can be edited' do
      post2 = FactoryBot.create(:second_post)
      expect(page).to have_content("Description 2")
    end
  end

  describe 'new' do
    it 'has a link from the homepage' do
      visit root_path

      click_link("new_post")
      expect(page.status_code).to eq(200)
    end
  end

  describe 'show' do
    before do
      post = FactoryBot.create(:post)
      visit post_path(post[:id])
    end

    it 'has a link from the show-page to index' do
      click_link("index_page")
      expect(page.status_code).to eq(200)
    end
  end
end

