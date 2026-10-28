require "rails_helper"

RSpec.describe "Emails TAPAS", type: :mailer do
  let!(:author) { create(:user, first_name: "Dalila") }
  let!(:member) { create(:user) }
  let(:post) { create(:post, user: author, client: "RIVP", title: "Concertation Saint-Blaise", deadline: Date.current + 5) }

  shared_examples "un email TAPAS envoyé à tous en copie cachée" do
    it "part de « TAPAS » et met les membres en copie cachée" do
      expect(mail[:from].display_names).to include("TAPAS")
      expect(mail.bcc).to include(author.email, member.email)
      expect(mail.to).not_to include(member.email)
    end

    it "contient le lien vers l'appel d'offres" do
      expect(mail.html_part.body.decoded).to include("/posts/#{post.id}")
      expect(mail.text_part.body.decoded).to include("/posts/#{post.id}")
    end
  end

  describe "nouvel appel d'offres" do
    let(:mail) { PostMailer.creation_confirmation(post) }
    include_examples "un email TAPAS envoyé à tous en copie cachée"

    it "affiche le client et le compte à rebours" do
      expect(mail.subject).to eq("Nouvel appel d'offres · RIVP")
      expect(mail.html_part.body.decoded).to include("J-5")
    end
  end

  describe "nouveau commentaire" do
    let(:comment) { post.comments.create!(body: "Je peux reprendre la note méthodo.", user: author) }
    let(:mail) { CommentMailer.creation_comment(post, comment) }
    include_examples "un email TAPAS envoyé à tous en copie cachée"

    it "cite le commentaire et son auteur" do
      html = mail.html_part.body.decoded
      expect(html).to include("Dalila a commenté")
      expect(html).to include("Je peux reprendre la note méthodo.")
    end
  end

  describe "une réponse se prépare" do
    let(:mail) { LikeMailer.creation_like(post, member) }
    include_examples "un email TAPAS envoyé à tous en copie cachée"

    it "nomme la personne qui prépare la réponse" do
      expect(mail.html_part.body.decoded).to include("#{member.first_name} prépare une réponse")
    end
  end

  describe "bienvenue" do
    let(:mail) { UserMailer.welcome(member) }

    it "est envoyé au nouveau membre uniquement" do
      expect(mail.to).to eq([member.email])
      expect(mail.html_part.body.decoded).to include("Bienvenue #{member.first_name}")
    end
  end

  describe "récap de la semaine" do
    it "s'affiche aussi sans activité" do
      mail = UserMailer.newsletter_mailer
      expect(mail.html_part.body.decoded).to include("Pas d'activité cette semaine")
    end
  end
end
