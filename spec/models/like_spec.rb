require 'rails_helper'

RSpec.describe Like, 'associations' do
  it { should belong_to(:user) }
  it { should belong_to(:recipe) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:recipe_id) }

end
