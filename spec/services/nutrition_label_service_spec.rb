#frozen_string_litereal: true

require 'rails_helper'

RSpec.describe 'Nutrition Label Service' do
  let!(:baguette) {{
    title: 'Baguette',
    ingr: [
      '1lb of flour',
      '10oz of water',
      '1/4oz yeast',
      '1/3oz salt'
    ]
  }}

  it 'exists' do
    VCR.use_cassette('label_service') do
      label = NutritionLabelService.new(baguette)

      expect(label).to be_a(NutritionLabelService)
    end
  end

  it 'returns an analyzed recipe' do
    VCR.use_cassette('analyzation') do
      attrs = %i[yield calories totalWeight totalNutrients totalDaily]
      label = NutritionLabelService.analyze_recipe(baguette)

      expect(label).not_to be_empty
      expect(attrs.all? {|s| label.key?(s)}).to be true
    end
  end
end
