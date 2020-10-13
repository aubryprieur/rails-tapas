puts 'Cleaning database...'
Post.destroy_all

puts "Creating Posts"

20.times do |post|
  Post.create!(deadline: Date.today, title: "title #{post}", description: "description #{post}")
end

puts "20 Posts have been created"
