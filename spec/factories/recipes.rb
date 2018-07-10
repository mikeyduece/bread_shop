FactoryBot.define do
  factory :recipe do
    sequence :name do |n|
      "#{n}Recipe"
    end
    user
    transient do
      ingredient_count 6
    end

    before(:create) do |_recipe, evaluator|
      create_list(:ingredient, evaluator.ingredient_count)
    end

    after(:create) do |recipe|
      create_list(:recipe_ingredient, 3, recipe: recipe)
    end
    family { Family.all.sample || association(:family) }
  end
end
