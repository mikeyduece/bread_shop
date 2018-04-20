require 'rails_helper'

RSpec.describe RecipeTag, 'associations' do
  it { should belong_to(:recipe) }
  it { should belong_to(:tag) }
end
