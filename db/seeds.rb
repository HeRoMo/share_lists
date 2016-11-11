# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Admin.create({email: 'admin@email.com', password: 'password', password_confirmation:'password'})
User.create({email: 'first@email.com', password: 'password', password_confirmation:'password'})

20.times do |i|
  List.create({
      title: "title-#{i}",
      items: "item-#{i}.1\nitem-#{i}.2\nitem-#{i}.3",
      owner: User.first
              })
end
