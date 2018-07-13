# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Recipe Requests' do
  let!(:user) { create(:user_with_recipes) }
  let!(:token) { TokiToki.encode(user.attributes) }
  let!(:recipe) { user.recipes[0] }

  it 'returns list of all recipes' do
    get '/api/v1/recipes'

    recipes = JSON.parse(response.body, symbolize_names: true)

    expect(recipes.length).to eq(4)
    recipes.each { |recipe| expect(recipe[:user][:name]).to eq(user.name) }
  end

  it 'returns specific recipe' do
    get "/api/v1/recipes/#{recipe.id}"

    return_recipe = JSON.parse(response.body, symbolize_names: true)


    expect(return_recipe[:user][:name]).to eq(user.name)
    expect(return_recipe[:name]).to eq(recipe.name)
  end
end
