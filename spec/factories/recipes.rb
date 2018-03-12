FactoryBot.define do
  factory :recipe do
    sequence :name do |n|
      "#{n}Recipe"
    end
    user
    sequence :family do |n|
      @family ||= %w(Lean Soft Rich Sweet Slack)
      @family.sample
    end
  end
end
