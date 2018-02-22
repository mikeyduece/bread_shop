FactoryBot.define do
  factory :recipe_ingredient do
    recipe
    ingredient
    sequence :amount do |n|
      @amount ||= (0.01..10.0).step(0.01).to_a.shuffle
      @amount[n]
    end
  end
end
