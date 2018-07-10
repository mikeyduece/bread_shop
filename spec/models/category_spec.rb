require 'rails_helper'

RSpec.describe Category, 'associations' do
  it { have_many(:ingredients) }
end

RSpec.describe Category, 'validations' do
  it { should validate_uniqueness_of :name }
  it { should validate_presence_of :name }
end
