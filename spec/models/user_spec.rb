require 'rails_helper'

RSpec.describe User, type: :model do
  it {should validate_uniqueness_of :email}
  it {should validate_uniqueness_of :uid}
  context 'Class Methods' do
    it '.from_auth' do
      user = User.from_auth(stub_omniauth)

      expect(user).to be_a(User)
      expect(user.name).to eq('Rick Astley')
      expect(user.email).to eq('rickastley@gmail.com')
      expect(user.uid).to eq('1234567890')
    end
  end
end
