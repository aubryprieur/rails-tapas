FactoryBot.define do
  factory :comment do
    body { "MyText" }
    commentable_id { 1 }
    commentable_type { "MyString" }
    user_id { 1 }
  end
end
