require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  it { should validate_uniqueness_of :name }

  it 'can assign categories' do
    fat_1 = Ingredient.create(name: 'butter')
    fat_2 = Ingredient.create(name: 'cream')
    sweet_1 = Ingredient.create(name: 'brown sugar')
    sweet_2 = Ingredient.create(name: 'honey')
    flour_1 = Ingredient.create(name: 'bread flour')
    flour_2 = Ingredient.create(name: 'semolina')
    water = Ingredient.create(name: 'water')

    expect(fat_1.category).to eq('fat')
    expect(fat_2.category).to eq('fat')
    expect(sweet_1.category).to eq('sweetener')
    expect(sweet_2.category).to eq('sweetener')
    expect(flour_1.category).to eq('flour')
    expect(flour_2.category).to eq('flour')
    expect(water.category).to eq('water')
  end
end
