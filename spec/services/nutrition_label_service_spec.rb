#frozen_string_litereal: true

require 'rails_helper'

RSpec.describe 'Nutrition Label Service' do
  let!(:recipe) {{
    title: 'Baguette',
    ingr: [
      '1lb of flour',
      '10 oz of water',
      '1/4 oz yeast',
      '1/3 oz salt'
    ]
  }}

  it 'exists' do
    VCR.use_cassette('label_service') do
      label = NutritionLabelService.new(recipe)

      expect(label).to be_a(NutritionLabelService)
    end
  end

  it 'returns an analyzed recipe' do
    VCR.use_cassette('analyzation') do
      label = NutritionLabelService.analyze_recipe(recipe)

      require 'pry'; binding.pry
      expect(label).to be_a(NutritionLabel)
    end
  end
end
