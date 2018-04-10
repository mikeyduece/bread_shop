FactoryBot.define do
  factory :user do
    name { Faker::Dune.character }
    sequence :uid do |n|
      "#{n}uid"
    end
    zipcode { Faker::Address.postcode }
    email { Faker::Internet.email }

    factory :user_with_recipes do
      after(:create) do |user|
        create_list(:recipe, 4, user: user)
      end
    end
  end
end
