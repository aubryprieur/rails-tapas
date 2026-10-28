require "rails_helper"

describe "Accueil" do
  it "renvoie vers la connexion quand on n'est pas connecté" do
    visit root_path
    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content("Connexion")
  end

  it "affiche le tableau de bord d'un membre connecté" do
    user = create(:user, first_name: "Dalila")
    create(:post, client: "MEL", title: "Évaluation FSL", deadline: Date.current + 2)
    login_as(user, scope: :user)

    visit root_path

    expect(page).to have_content("Bonjour Dalila !")
    expect(page).to have_content("Échéances les plus proches")
    expect(page).to have_content("Évaluation FSL")
  end
end
