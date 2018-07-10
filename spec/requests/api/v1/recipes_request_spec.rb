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

        expect(attrs.all? {|s| label.key?(s)}).to be true
      end
    end
  end

  context 'calculate new amounts' do
    it 'calculates new amounts from new total dough weight' do
      VCR.use_cassette('new_recipe') do
        list = {
          name: 'baguette1',
          ingredients: {
            flour: { amount: 1.00 },
            water: { amount: 0.62 },
            yeast: { amount: 0.02 },
            salt: { amount: 0.02 }
          }
        }

        post "/api/v1/users/#{user.email}/recipes", params: {
          token: token,
          recipe: list
        }

        original_recipe = JSON.parse(response.body, symbolize_names: true)

        get "/api/v1/recipes/#{list[:name]}/new_totals", params: {
          token: token,
          recipe: original_recipe[:recipe],
          new_dough_weight: 3.32
        }

        expect(response).to be_successful

        new_totals = JSON.parse(response.body, symbolize_names: true)

        expect(new_totals[:ingredients][:flour][:amount]).to eq(2.0)
        expect(new_totals[:ingredients][:water][:amount]).to eq(1.24)
        expect(new_totals[:ingredients][:yeast][:amount]).to eq(0.04)
        expect(new_totals[:ingredients][:salt][:amount]).to eq(0.04)
      end
    end

    it 'calculates different amounts from different total dough weight' do
      VCR.use_cassette('new_recipe') do
        list = {
          name: 'baguette2',
          ingredients: {
            flour: { amount: 1.00 },
            water: { amount: 0.62 },
            yeast: { amount: 0.02 },
            salt: { amount: 0.02 }
          }
        }

        post "/api/v1/users/#{user.email}/recipes", params: {
          token: token,
          recipe: list
        }

        original_recipe = JSON.parse(response.body, symbolize_names: true)

        get "/api/v1/recipes/#{list[:name]}/new_totals", params: {
          token: token,
          recipe: original_recipe[:recipe],
          new_dough_weight: 10.0
        }

        expect(response).to be_successful

        new_totals = JSON.parse(response.body, symbolize_names: true)

        expect(new_totals[:ingredients][:flour][:amount]).to eq(6.02)
        expect(new_totals[:ingredients][:water][:amount]).to eq(3.73)
        expect(new_totals[:ingredients][:yeast][:amount]).to eq(0.12)
        expect(new_totals[:ingredients][:salt][:amount]).to eq(0.12)
      end
    end
  end
end
