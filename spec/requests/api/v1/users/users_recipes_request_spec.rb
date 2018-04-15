require 'rails_helper'

RSpec.describe 'User API' do
  let!(:user) { create(:user) }
  let!(:token) { TokiToki.encode(user.attributes) }
  let!(:recipe) { create(:recipe, user: user) }

  context 'Authorization' do
    it 'should return token' do
      get api_v1_auth_amazon_path, params: stub_omniauth

      expect(response).to be_success

      user_json = JSON.parse(response.body, symbolize_names: true)

      expect(user_json[:token]).to match(/^[a-zA-Z0-9\-_]+?\.[a-zA-Z0-9\-_]+?\.([a-zA-Z0-9\-_]+)?$/)
      expect(user_json[:status]).to eq(200)
    end
  end

  context 'user recipes' do
    it 'returns list of recipes for a user with params' do
      user.recipes = create_list(:recipe, 4, user: user)
      user.recipes.each do |x|
        x.recipe_ingredients = create_list(:recipe_ingredient, 6)
      end

      get "/api/v1/users/#{user.email}/recipes", params: { token: token }

      expect(response).to be_success

      recipes = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(recipes.count).to eq(4)
    end

    it 'does not return anything without token in params' do
      user.recipes = create_list(:recipe, 4, user: user)
      user.recipes.each do |x|
        x.recipe_ingredients = create_list(:recipe_ingredient, 6)
      end

      get "/api/v1/users/#{user.email}/recipes"

      expect(response).to_not be_success
      expect(response).to have_http_status(401)
    end

    it 'returns recipe with ingredients and total percentage' do
      user.recipes = create_list(:recipe, 4, user: user)
      user.recipes.each do |x|
        x.recipe_ingredients = create_list(:recipe_ingredient, 6)
      end
      recipe = user.recipes[0]
      flour  = create(:ingredient, name: 'flour')
      recipe.recipe_ingredients << create(:recipe_ingredient, ingredient_id: flour.id)

      get "/api/v1/users/#{user.email}/recipes/#{recipe.name}",
        params: { token: token }

      expect(response).to be_success

      json_recipe = JSON.parse(response.body, symbolize_names: true)

      expect(json_recipe[:status]).to eq(200)
      expect(json_recipe[:recipe][:name]).to eq(recipe.name)
      expect(json_recipe[:recipe][:ingredients].length).to eq(7)
    end

    it 'can create recipe' do
      user.recipes = create_list(:recipe, 4, user: user)
      user.recipes.each do |x|
        x.recipe_ingredients = create_list(:recipe_ingredient, 6)
      end
      list = {
        name: 'baguette',
        ingredients: {
          flour: { amount: 1.00 },
          water: { amount: 0.62 },
          yeast: { amount: 0.02 },
          salt: { amount: 0.02 }
        }
      }

      post "/api/v1/users/#{user.email}/recipes",
        params: { token: token, recipe: list }

      expect(response).to be_success
      expect(Recipe.exists?(name: 'baguette')).to be(true)
      expect(Ingredient.any? { list[:ingredients].keys }).to be(true)
      expect(RecipeIngredient.any? { list[:ingredients].values }).to be(true)
    end

    it 'user can delete recipe' do
      user.recipes = create_list(:recipe, 4, user: user)
      user.recipes.each do |x|
        x.recipe_ingredients = create_list(:recipe_ingredient, 6)
      end
      recipe = user.recipes[0]
      flour  = create(:ingredient, name: 'Flour')
      recipe.recipe_ingredients << create(:recipe_ingredient, ingredient_id: flour.id)

      delete "/api/v1/users/#{user.email}/recipes/#{recipe.name}",
        params: { token: token }

      expect(response).to be_success

      deleted = JSON.parse(response.body, symbolize_names: true)

      expect(deleted[:status]).to eq(204)
      expect(deleted[:message]).to eq("Successfully deleted #{recipe.name}")
      expect(Recipe.all).not_to include(recipe.id)
    end

    it 'returns the family of the recipe' do
      user.recipes << Recipe.create(name: 'baguette', user_id: user.id)
      recipe = Recipe.find_by(name: 'baguette')
      flour  = Ingredient.create(name: 'flour', category: 'flour')
      water  = Ingredient.create(name: 'water', category: 'water')
      salt   = Ingredient.create(name: 'salt')
      yeast  = Ingredient.create(name: 'yeast')
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour.id, amount: 1.0)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: water.id, amount: 0.63)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: salt.id, amount: 0.02)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: yeast.id, amount: 0.03)

      get "/api/v1/users/#{user.email}/recipes/#{user.recipes[-1].name}",
        params: { token: token }

      expect(response).to be_success

      return_recipe = JSON.parse(response.body, symbolize_names: true)

      expect(return_recipe[:recipe][:family]).to eq('Lean')
    end

    it 'returns list of all recipes grouped by family' do
      user.recipes = create_list(:recipe, 10, user: user)
      user.recipes.each do |x|
        x.recipe_ingredients = create_list(:recipe_ingredient, 6)
      end

      get '/api/v1/families', params: { token: token }

      expect(response).to be_success

      families = JSON.parse(response.body, symbolize_names: true)

      family_names = %w[Lean Soft Rich Sweet Slack].map(&:to_sym)
      expect(families).to be_a(Hash)
      expect(families.keys).to include(*family_names)
    end

    it 'returns list of recipes that align with requested family' do
      user.recipes = create_list(:recipe, 4, user: user)
      user.recipes.each do |x|
        x.recipe_ingredients = create_list(:recipe_ingredient, 6)
      end
      recipe = user.recipes[0]

      get "/api/v1/families/#{recipe.family}", params: { token: token }

      expect(response).to be_success

      family = JSON.parse(response.body, symbolize_names: true)

      expect(family.all? { |hash| hash[:family] == recipe.family }).to be true
    end
  end

  context 'calculate new amounts' do
    it 'calculates new amounts from new total dough weight' do
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

      get "/api/v1/recipes/#{recipe[:name]}/new_totals", params: {
        token: token,
        recipe: original_recipe[:recipe],
        new_dough_weight: 3.32
      }

      expect(response).to be_success

      new_totals = JSON.parse(response.body, symbolize_names: true)

      expect(new_totals[:ingredients][:flour][:amount]).to eq(2.0)
      expect(new_totals[:ingredients][:water][:amount]).to eq(1.24)
      expect(new_totals[:ingredients][:yeast][:amount]).to eq(0.04)
      expect(new_totals[:ingredients][:salt][:amount]).to eq(0.04)
    end

    it 'calculates different amounts from different total dough weight' do
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

      get "/api/v1/recipes/#{recipe[:name]}/new_totals", params: {
        token: token,
        recipe: original_recipe[:recipe],
        new_dough_weight: 10.0
      }

      expect(response).to be_success

      new_totals = JSON.parse(response.body, symbolize_names: true)

      expect(new_totals[:ingredients][:flour][:amount]).to eq(6.02)
      expect(new_totals[:ingredients][:water][:amount]).to eq(3.73)
      expect(new_totals[:ingredients][:yeast][:amount]).to eq(0.12)
      expect(new_totals[:ingredients][:salt][:amount]).to eq(0.12)
    end
  end
end
