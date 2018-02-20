FactoryBot.define do
  factory :ingredient do
    sequence :name do |n|
      "#{n}Mystring"
    end
  end
end
