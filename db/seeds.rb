# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

2.times do |i|
  User.create(username: Faker::Internet.username, password: "123456", email: "thp.fake#{i + 1}@yopmail.com")
end

2.times do |i|
  Lesson.create(user: User.all[i], title: Faker::Games::Zelda.game, description: Faker::Lorem.sentence(word_count: 10))
end

2.times do |i|
  Booking.create(user: User.all[i], lesson: Lesson.all[i], start_date: DateTime.now + i, duration: 30)
end

# starting time
start_time = Date.today + 1.day + 10.hour
user = User.first

10.times do
  Schedule.create(title: "available", start_time: start_time, end_time: start_time + 30.minute, user: user)
  start_time += 30.minute
end
