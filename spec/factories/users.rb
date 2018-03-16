FactoryBot.define do
  factory :user do
    name { Faker::Dune.character }
    sequence :uid do
      |n| "#{n}uid"
    end
    zipcode { Faker::Address.postcode }
    email { Faker::Internet.email }
    #sequence :email do |n|
      #"#{n}myemail@gmail.com"
    #end
  end
end
