require 'rails_helper'

describe 'navigate' do
  describe 'index' do
    it 'can be reached successfully' do
      visit posts_path
      expect(page.status_code).to eq(200)
    end
    it 'has a title of Posts' do
      visit posts_path
      expect(page).to have_content(/Liste des appels d'offres/)
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

  end
end

