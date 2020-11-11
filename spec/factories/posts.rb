FactoryBot.define do
  factory :post do
    deadline {Date.today}
    title {"Appel d'offres 1"}
    description {"Description1"}
    user
  end

  factory :second_post, class: "Post" do
    deadline {Date.today}
    title {"Appel d'offres 2"}
    description {"Description 2"}
    user
  end
end
