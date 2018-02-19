FactoryBot.define do
  factory :user do
    name "MyString"
    uid "MyString"
    sequence :uid do
      |n| "#{n}uid"
    end
    zipcode "MyString"
    sequence :email do |n|
      "#{n}myemail@gmail.com"
    end
  end
end
