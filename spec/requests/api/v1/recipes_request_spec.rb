# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Recipe Requests' do
  let!(:user) { create(:user_with_recipes) }
  let!(:recipe) { user.recipes[0] }

  it 'returns list of all recipes' do
    get '/api/v1/recipes'

    expect(response).to be_successful

    recipes = JSON.parse(response.body, symbolize_names: true)

    expect(recipes.length).to eq(4)
    recipes.each { |recipe| expect(recipe[:user][:name]).to eq(user.name) }
  end

  it 'returns specific recipe' do
    get "/api/v1/recipes/#{recipe.id}"

    expect(response).to be_successful

    return_recipe = JSON.parse(response.body, symbolize_names: true)


    expect(return_recipe[:user][:name]).to eq(user.name)
    expect(return_recipe[:name]).to eq(recipe.name)
  end

  context 'Pagination' do
    it 'can paginate' do
      create_list(:recipe, 25)

      get '/api/v1/recipes'

      expect(response).to be_successful

      recipes = JSON.parse(response.body, symbolize_names: true)

      expect(recipes.count).to eq(10)

      get '/api/v1/recipes', params: { page: 3 }

      expect(response).to be_successful

      paginated_recipes = JSON.parse(response.body, symbolize_names: true)

      expect(paginated_recipes.count).to eq(9)
    end

    it 'can change per_page' do
      create_list(:recipe, 50)

      get '/api/v1/recipes', params: { per_page: 25}

      expect(response).to be_successful

      recipes = JSON.parse(response.body, symbolize_names: true)

      expect(recipes.count).to eq(25)

      get '/api/v1/recipes', params: { per_page: 5 }

      expect(response).to be_successful

      paginated_recipes = JSON.parse(response.body, symbolize_names: true)

      expect(paginated_recipes.count).to eq(5)

      get '/api/v1/recipes', params: { per_page: 30 }

      expect(response).to be_successful

      larger_return = JSON.parse(response.body, symbolize_names: true)

      expect(larger_return.count).to eq(30)
    end
  end
end
