FactoryBot.define do
  factory :post do
    deadline {Date.today}
    client {"Client1"}
    title {"Appel d'offres 1"}
    rich_body {"Description1"}
    user
  end

  factory :second_post, class: "Post" do
    deadline {Date.today}
    client {"Client2"}
    title {"Appel d'offres 2"}
    rich_body {"Description 2"}
    user
  end
end
