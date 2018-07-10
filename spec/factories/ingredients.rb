FactoryBot.define do
  factory :ingredient do
    sequence :name do |n|
      "#{n}Ingredient"
    end
    category
  end
end
