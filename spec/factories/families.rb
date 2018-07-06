FactoryBot.define do
  factory :family do
    sequence :name do
      @name ||= %w[Lean Soft Rich Sweet Slack]
      @name.sample
    end
  end
end
