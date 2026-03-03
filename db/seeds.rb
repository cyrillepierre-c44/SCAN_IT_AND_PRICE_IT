# 1. Clean the database 🗑️
puts "Cleaning database..."
Request.destroy_all
User.destroy_all

#2. Create the instances 🏗️
puts "Creating users..."
sarah = User.create!(email: "sarah@sarah.com", password: "123456")
toni = User.create!(email: "toni@toni.com", password: "123456")

puts "Creating requests..."
Request.create!(cleanliness: "Très sale", fullness: false, newness: false)
Request.create!(cleanliness: "Très propre", fullness: true , newness: true)

# 3. Display a message 🎉
puts "Finished! Created #{Request.count} requests."
