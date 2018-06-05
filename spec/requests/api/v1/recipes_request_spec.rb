# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'New recipe amount calculation' do
  let!(:user) { create(:user) }
  let!(:token) { TokiToki.encode(user.attributes) }

  context 'calculate new amounts' do
    it 'calculates new amounts from new total dough weight' do
      VCR.use_cassette('new_recipe') do
        list = {
          name: 'baguette',
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
          name: 'baguette',
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
