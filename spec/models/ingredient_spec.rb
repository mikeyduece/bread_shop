# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ingredient, 'validations' do
  it { should validate_uniqueness_of :name }
end

RSpec.describe Ingredient, 'associations' do
  it { should have_many(:recipe_ingredients).dependent(:destroy) }
  it { should have_many(:recipes).through(:recipe_ingredients) }
end

RSpec.describe Ingredient, type: :model do
  it '#assign_category' do
    fat1 = Ingredient.create(name: 'butter')
    fat2 = Ingredient.create(name: 'cream')
    sweet1 = Ingredient.create(name: 'brown sugar')
    sweet2 = Ingredient.create(name: 'honey')
    flour1 = Ingredient.create(name: 'bread flour')
    flour2 = Ingredient.create(name: 'semolina')
    water = Ingredient.create(name: 'water')

    expect(fat1.category).to eq('fat')
    expect(fat2.category).to eq('fat')
    expect(sweet1.category).to eq('sweetener')
    expect(sweet2.category).to eq('sweetener')
    expect(flour1.category).to eq('flour')
    expect(flour2.category).to eq('flour')
    expect(water.category).to eq('water')
  end
end
