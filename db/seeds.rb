# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

User.create!(email: "admin@gmail.com", password: "admin123", username: "admin", user_type: "admin")
Plan.create!(plan_type: 'Free', available_notifications: 100)
Plan.create!(plan_type: '$20', available_notifications: 1000)
Plan.create!(plan_type: '$40', available_notifications: 100000)


# Status.create!(name: "operational", user_id: 1)
# Status.create!(name: "Degraded performance", user_id: 1)
# Status.create!(name: "Partial outage", user_id: 1)
# Status.create!(name: "Major outage", user_id: 1)