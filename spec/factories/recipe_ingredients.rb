FactoryBot.define do
  factory :recipe_ingredient do
    recipe
    ingredient
    sequence :amount do |n|
      @amount ||= (1..100).to_a.shuffle
      @amount[n]
    end
  end
end
