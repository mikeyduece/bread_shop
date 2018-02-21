FactoryBot.define do
  factory :recipe do
    sequence :name do |n|
      "#{n}Recipe"
    end
    user
  end
end
