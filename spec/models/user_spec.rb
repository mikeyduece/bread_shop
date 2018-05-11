require 'rails_helper'

RSpec.describe User, 'validations' do
  %w[email uid].each do |field|
    it { should validate_uniqueness_of(field) }
  end
end

RSpec.describe User, 'associations' do
  it { should have_many(:recipes) }
  it { should have_many(:likes).dependent(:destroy) }

  it 'different users can have same recipe name' do
    user1 = create(:user)
    user2 = create(:user)
    recipe1 = Recipe.create(user_id: user1.id, name: 'Bread')
    recipe2 = Recipe.create(user_id: user2.id, name: 'Bread')

    expect(recipe1.name).to eq(recipe2.name)
  end
end

RSpec.describe User, type: :model do
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
