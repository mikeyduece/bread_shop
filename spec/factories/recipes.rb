FactoryBot.define do
  factory :recipe do
    sequence :name do |n|
      "#{n}MyString"
    end
    user
  end
end
