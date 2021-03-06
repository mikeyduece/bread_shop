# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rails db:seed command (or created
# alongside the database with db:setup).
#
# Examples:
#
# movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# Character.create(name: 'Luke', movie: movies.first)

Family.delete_all

%w[Lean Soft Sweet Slack Rich].each do |name|
  Family.create(name: name)
end

Category.delete_all

%w[sweetener fat flour water].each do |name|
  Category.create(name: name)
end
