FactoryBot.define do
  factory :ingredient do
    sequence :name do |n|
      "#{n}Ingredient"
    end

    sequence :category do
      @category ||= %w[sweetener fat flour water]
      @category.sample
    end
  end
end
