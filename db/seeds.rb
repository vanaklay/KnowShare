# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# starting time
start_time = Date.today + 1.day + 10.hour
user = User.find(1)

20.times do 
  Schedule.create(title: "available", start_time: start_time, end_time: start_time + 30.minute, user: user)
  start_time += 30.minute
end
