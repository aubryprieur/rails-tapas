require "rails_helper"

RSpec.describe PostsHelper, type: :helper do
  describe "#deadline_info" do
    def info(days) = helper.deadline_info(Post.new(deadline: Date.current + days))

    it "affiche un compte à rebours et une couleur selon l'urgence" do
      expect(info(10)).to include(status: "ok", label: "J-10")
      expect(info(6)).to include(status: "soon", label: "J-6")
      expect(info(3)).to include(status: "urgent", label: "J-3")
      expect(info(1)).to include(status: "urgent", label: "Demain")
      expect(info(0)).to include(status: "urgent", label: "Aujourd'hui")
      expect(info(-2)).to include(status: "past", label: "Échéance dépassée")
    end
  end
end
