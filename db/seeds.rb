# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'faker'

(0..10).each do |i|
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    username = Faker::Twitter.unique.screen_name
    
    User.create(
      first_name: first_name,
      last_name: last_name,
      username: username,
      email: Faker::Internet.email(name: "#{first_name} #{last_name}"),
      password: "1234",
      password_confirmation: "1234"
    )
  end


categories = ["Home", "Work", "Clothes", "Electronics"]
locations = ["Lviv", "IvanoFrankivsk", "Rivne", "Ternopil"]

40.times do
  Advertisement.create(
    title: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph,
    category: categories.sample,
    location: locations.sample,
    user_id: rand(1..15)
  )
end