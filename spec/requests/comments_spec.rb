require "rails_helper"

RSpec.describe "Commentaires", type: :request do
  let(:author) { create(:user, first_name: "Dalila") }
  let(:other)  { create(:user) }
  let(:admin)  { create(:admin_user) }
  let(:ao)     { create(:post) }

  before { ActionMailer::Base.deliveries.clear }

  describe "envoi" do
    before { sign_in_as(author) }

    it "enregistre le message au nom de la personne connectée, même si on tente d'en usurper une autre" do
      post post_comments_path(ao), params: { comment: { body: "Bonjour", user_id: other.id } }

      expect(ao.comments.last.user).to eq(author)
      expect(response).to redirect_to(post_path(ao, anchor: "commentaires"))
    end

    it "ignore un doublon envoyé dans la minute (double clic)" do
      2.times { post post_comments_path(ao), params: { comment: { body: "Même message" } } }

      expect(ao.comments.where(body: "Même message").count).to eq(1)
      expect(ActionMailer::Base.deliveries.size).to eq(1)
    end

    it "accepte le même texte plus tard" do
      ao.comments.create!(body: "Ok", user: author, created_at: 5.minutes.ago)
      post post_comments_path(ao), params: { comment: { body: "Ok" } }

      expect(ao.comments.where(body: "Ok").count).to eq(2)
    end

    it "refuse un message vide" do
      post post_comments_path(ao), params: { comment: { body: "   " } }
      expect(ao.comments.count).to eq(0)
    end
  end

  describe "modification et suppression" do
    let!(:comment) { ao.comments.create!(body: "Texte initial", user: author) }

    it "permet à l'auteur de modifier son message" do
      sign_in_as(author)
      patch post_comment_path(ao, comment), params: { comment: { body: "Texte corrigé" } }

      expect(comment.reload.body).to eq("Texte corrigé")
      expect(response).to redirect_to(post_path(ao, anchor: "commentaire-#{comment.id}"))
    end

    it "permet à l'auteur de supprimer son message" do
      sign_in_as(author)
      delete post_comment_path(ao, comment)

      expect(Comment.exists?(comment.id)).to be(false)
    end

    it "empêche un autre membre de modifier ou supprimer le message" do
      sign_in_as(other)
      patch post_comment_path(ao, comment), params: { comment: { body: "Piraté" } }
      delete post_comment_path(ao, comment)

      expect(comment.reload.body).to eq("Texte initial")
    end

    it "empêche aussi un admin de toucher au message d'un autre" do
      sign_in_as(admin)
      delete post_comment_path(ao, comment)

      expect(Comment.exists?(comment.id)).to be(true)
    end

    it "refuse de vider un message en le modifiant" do
      sign_in_as(author)
      patch post_comment_path(ao, comment), params: { comment: { body: "" } }

      expect(comment.reload.body).to eq("Texte initial")
    end
  end

  def sign_in_as(user)
    login_as(user, scope: :user)
  end
end
