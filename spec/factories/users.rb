FactoryBot.define do
  sequence :email do |n|
    "test#{n}@example.com"
  end

  factory :user, class: User do
    first_name { "Jon" }
    last_name  { "Snow" }
    email { generate :email }
    password { "somepassword" }
    password_confirmation { "somepassword"}
  end

  factory :second_user, class: User do
    first_name { "Tiffany" }
    last_name  { "Hudgens" }
    email { generate :email }
    password { "azertyui" }
    password_confirmation { "azertyui"}
  end

  factory :admin_user, class: "AdminUser" do
    first_name { "Admin" }
    last_name  { "User" }
    email { generate :email }
    password { "somepassword" }
    password_confirmation { "somepassword"}
  end
end
