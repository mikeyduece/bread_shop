require 'rails_helper'

RSpec.describe User, type: :model do
  %w[email uid].each do |field|
    it { should validate_uniqueness_of(field) }
  end

  context 'Class Methods' do
    it '.from_auth' do
      user = User.from_auth(stub_omniauth[:user_info])

      expect(user).to be_a(User)
      expect(user.name).to eq('Rick Astley')
      expect(user.email).to eq('rickastley@gmail.com')
      expect(user.uid).to eq('1234567890')
    end
  end
end
