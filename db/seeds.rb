puts 'Cleaning database...'
User.destroy_all
Post.destroy_all

puts "Creating Users"
user1 = User.create!(email: "aubry.prieur@gmail.com", first_name: "Aubry", last_name: "Prieur", password: "Copas123456", password_confirmation: "Copas123456")
puts "User have been created"

puts "Creating Posts"

20.times do |post|
  Post.create!(deadline: Date.today, title: "title #{post}", description: "description #{post}", user_id: user1.id )
end

puts "20 Posts have been created"
