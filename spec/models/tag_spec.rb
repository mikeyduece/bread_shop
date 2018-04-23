require 'rails_helper'

RSpec.describe Tag, 'validations' do
  it { should validate_presence_of :name }
end

RSpec.describe Tag, 'associations' do
  it { should have_many(:recipes).through(:recipe_tags) }
end

