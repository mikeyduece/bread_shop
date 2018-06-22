#frozen_string_litereal: true
require 'rails_helper'

RSpec.describe 'Nutrition Label Service' do
  let!(:baguette) {{
    title: 'baguette',
    ingr: [
      '1lb of flour',
      '10oz of water',
      '1/4oz yeast',
      '1/3oz salt'
    ]
  }}
  let(:user) { create(:user_with_recipes)}
  let(:recipe) { user.recipes[0]}

  it 'exists' do
    VCR.use_cassette('label_service', :allow_playback_repeats => true) do
      label = NutritionLabelService.new(baguette)

      expect(label).to be_a(NutritionLabelService)
    end
  end

  it 'can format a recipe for label api call' do
    VCR.use_cassette('formatting', :allow_playback_repeats => true) do
      attrs = %i[yield calories totalWeight totalNutrients totalDaily]
      %w[flour water salt yeast].each do |name|
        ing = create(:ingredient, name: name)
        create(:recipe_ingredient, recipe: recipe, ingredient: ing)
      end

      label = NutritionLabelService.analyze_recipe(recipe)

      expect(label).not_to be_empty
      expect(attrs.all? {|s| label.key?(s)}).to be true
    end
  end
end
