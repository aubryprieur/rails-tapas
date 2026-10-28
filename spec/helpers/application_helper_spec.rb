require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#shorten_for_filename" do
    it "supprime les accents et les espaces" do
      expect(helper.send(:shorten_for_filename, "Métropole Européenne de Lille", 60))
        .to eq("Metropole-Europeenne-de-Lille")
    end

    it "coupe entre deux mots sans dépasser la limite" do
      result = helper.send(:shorten_for_filename, "Régie Immobilière de la Ville de Paris", 30)
      expect(result).to eq("Regie-Immobiliere-de-la-Ville")
      expect(result.length).to be <= 30
    end

    it "coupe un mot unique trop long" do
      expect(helper.send(:shorten_for_filename, "a" * 50, 30)).to eq("a" * 30)
    end
  end

  describe "#post_attachment_name" do
    it "assemble client et mission" do
      post = Post.new(client: "RIVP", title: "Accompagnement politique de la ville")
      expect(helper.send(:post_attachment_name, post)).to eq("RIVP_Accompagnement-politique-de-la-ville")
    end
  end

  describe "#attachment_flag" do
    it "produit le paramètre Cloudinary" do
      expect(helper.send(:attachment_flag, "RIVP_Mission")).to eq("fl_attachment:RIVP_Mission")
    end

    it "revient au paramètre simple sans nom" do
      expect(helper.send(:attachment_flag, nil)).to eq("fl_attachment")
    end
  end
end
