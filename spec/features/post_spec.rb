require "rails_helper"

describe "Appels d'offres" do
  let(:user)  { create(:user) }
  let(:admin) { create(:admin_user) }
  let!(:ao)   { create(:post, client: "RIVP", title: "Concertation Saint-Blaise", deadline: Date.current + 10) }

  describe "liste" do
    before do
      create(:second_post, title: "Diagnostic Belleville", deadline: Date.current + 3)
      login_as(user, scope: :user)
      visit posts_path
    end

    it "s'affiche avec son titre" do
      expect(page.status_code).to eq(200)
      expect(page).to have_css("h1", text: "Appels d'offres")
    end

    it "affiche les appels d'offres en cours avec leur compte à rebours" do
      expect(page).to have_content("Concertation Saint-Blaise")
      expect(page).to have_content("Diagnostic Belleville")
      expect(page).to have_content("J-10")
      expect(page).to have_content("J-3")
    end

    it "propose le filtre « Nouveaux » avec le nombre d'AO publiés ces 7 derniers jours" do
      ao.update_columns(created_at: 10.days.ago)
      visit posts_path

      expect(page).to have_button("Nouveaux 1")
      expect(page).to have_css('[data-new="true"]', count: 1)
      expect(page).to have_css('[data-new="false"]', count: 1)
    end

    it "permet d'ouvrir la fiche en cliquant sur le titre" do
      click_link "Concertation Saint-Blaise"
      expect(page).to have_current_path(post_path(ao))
    end
  end

  describe "fiche" do
    it "affiche le client, le positionnement et les commentaires" do
      login_as(user, scope: :user)
      visit post_path(ao)

      expect(page).to have_content("RIVP")
      expect(page).to have_content("Positionnement")
      expect(page).to have_content("Je lis l'AO")
      expect(page).to have_content("Commentaires")
    end

    it "a un lien de retour vers la liste" do
      login_as(user, scope: :user)
      visit post_path(ao)

      click_link "Tous les appels d'offres"
      expect(page).to have_current_path(posts_path)
    end

    it "ne montre pas Modifier / Supprimer à un membre non admin" do
      login_as(user, scope: :user)
      visit post_path(ao)

      expect(page).not_to have_link("Modifier")
      expect(page).not_to have_link("Supprimer")
    end
  end

  describe "création" do
    it "est réservée aux admins" do
      login_as(user, scope: :user)
      visit new_post_path

      expect(page).to have_current_path(posts_path)
      expect(page).to have_content("Vous n'êtes pas autorisé")
    end

    it "est accessible depuis la barre de navigation" do
      login_as(admin, scope: :user)
      visit root_path

      click_link "new_post"
      expect(page).to have_current_path(new_post_path)
    end

    it "crée un appel d'offres rattaché à son auteur" do
      login_as(admin, scope: :user)
      visit new_post_path

      fill_in "post[client]", with: "Un client"
      fill_in "post[title]", with: "Un titre"
      fill_in "post[deadline]", with: (Date.current + 15).to_s
      click_button "Publier l'appel d'offres"

      expect(page).to have_content("Un titre")
      expect(Post.last.title).to eq("Un titre")
      expect(Post.last.user).to eq(admin)
    end

    it "affiche les erreurs en français si un champ obligatoire manque" do
      login_as(admin, scope: :user)
      visit new_post_path

      fill_in "post[client]", with: "Un client"
      fill_in "post[title]", with: "Un titre"
      click_button "Publier l'appel d'offres"

      expect(page).to have_content("Merci de corriger")
      expect(page).to have_content("Date limite de réponse")
      expect(Post.where(title: "Un titre")).to be_empty
    end
  end

  describe "modification" do
    it "permet à un admin de modifier un appel d'offres depuis sa fiche" do
      login_as(admin, scope: :user)
      visit post_path(ao)

      click_link "Modifier"
      fill_in "post[title]", with: "Nouveau titre"
      click_button "Enregistrer les modifications"

      expect(page).to have_content("Nouveau titre")
      expect(ao.reload.title).to eq("Nouveau titre")
    end
  end
end
