require "rails_helper"

describe "Favoris" do
  let(:user) { create(:user) }

  before { login_as(user, scope: :user) }

  it "affiche le calendrier du mois en cours" do
    visit favorites_path

    expect(page).to have_css("h1", text: "Mes favoris")
    expect(page).to have_content(I18n.l(Date.current, format: "%B %Y").upcase_first)
  end

  it "place un favori à sa date limite et ouvre sa fiche" do
    deadline = Date.current.end_of_month
    ao = create(:post, client: "RIVP", title: "Concertation Saint-Blaise", deadline: deadline)
    Favorite.create!(favorited: ao, user: user)

    visit favorites_path(month: deadline.strftime("%Y-%m"))

    within(".fav-grid") do
      expect(page).to have_content("RIVP")
      click_link "Concertation Saint-Blaise"
    end
    expect(page).to have_current_path(post_path(ao))
  end

  it "propose la prochaine échéance quand le mois affiché est vide" do
    ao = create(:post, deadline: Date.current.next_month.end_of_month)
    Favorite.create!(favorited: ao, user: user)

    visit favorites_path(month: Date.current.strftime("%Y-%m"))

    expect(page).to have_content("Prochaine échéance")
  end

  it "ignore un mois mal formé" do
    visit favorites_path(month: "n'importe quoi")
    expect(page.status_code).to eq(200)
  end
end
