FactoryBot.define do
  factory :recipe do
    family
    sequence :name do |n|
      "#{n}Recipe"
    end
    user
  end
end
