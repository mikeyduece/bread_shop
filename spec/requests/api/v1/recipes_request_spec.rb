# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'New recipe amount calculation' do
  let!(:user) { create(:user_with_recipes) }
  let!(:token) { TokiToki.encode(user.attributes) }
  let!(:recipe) { user.recipes[0] }

  context 'Nutrition Label' do
    it 'fetches label' do
      VCR.use_cassette('label') do
        recipe.recipe_ingredients.clear
        %w[flour water salt yeast].each do |name|
        ing = create(:ingredient, name: name)
        recipe.recipe_ingredients << create(:recipe_ingredient, recipe: recipe, ingredient: ing)
      end
        attrs = %i[yield calories totalNutrients healthLabels totalDaily]
        get "/api/v1/recipes/#{user.recipes[0].name}/label", params: {
          token: token
        }

        expect(response).to be_successful

        label = JSON.parse(response.body, symbolize_names: true)

        expect(attrs.all? { |s| label.key?(s) }).to be true
      end
    end
  end
end
