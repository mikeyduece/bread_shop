require 'rails_helper'

RSpec.describe 'User API' do
  let(:user) { create(:user_with_recipes) }
  let!(:token) { TokiToki.encode(user.attributes) }

  context 'Authorization' do
    it 'should return token' do
      get api_v1_auth_amazon_path, params: stub_omniauth

      expect(response).to be_successful

      user_json = JSON.parse(response.body, symbolize_names: true)

      expect(user_json[:user][:name]).to eq(stub_omniauth['user_info']['info']['name'])
      expect(user_json[:token]).to match(/^[a-zA-Z0-9\-_]+?\.[a-zA-Z0-9\-_]+?\.([a-zA-Z0-9\-_]+)?$/)
      expect(response.status).to eq(200)
    end
  end

  context 'user recipes' do
    it 'returns list of recipes for a user with params' do
      get "/api/v1/users/#{user.id}/recipes", params: { token: token }

      expect(response).to be_successful

      recipes = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(recipes.count).to eq(4)
    end

    it 'does not return anything without token in params' do
      get "/api/v1/users/#{user.id}/recipes"

      expect(response).to_not be_successful
      expect(response).to have_http_status(401)
    end

    it 'returns recipe with ingredients and total percentage' do
      recipe = user.recipes[0]
      %w[bread awesome].each do |tag_name|
        recipe.tags << create(:tag, name: tag_name)
      end

      recipe.recipe_ingredients.clear
      flour  = create(:ingredient, name: 'flour')
      recipe.recipe_ingredients << create(:recipe_ingredient, ingredient_id: flour.id)
      6.times do
        create(:recipe_ingredient, recipe: recipe)
      end

      get "/api/v1/users/#{user.id}/recipes/#{recipe.id}",
        params: { token: token }

      expect(response).to be_successful

      json_recipe = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(json_recipe[:name]).to eq(recipe.name)
      expect(json_recipe[:id]).to eq(recipe.id)
      expect(json_recipe[:ingredient_list].length).to eq(7)
    end

    it 'can create recipe' do
      VCR.use_cassette('new_recipes') do
        ingredient_names = %w[flour water yeast salt]
        ingredient_amounts = [1.00, 0.62, 0.02, 0.02]
        list = {
          name: 'baguette',
          ingredients: [
            { name: 'flour', amount: 1.00 },
            { name: 'water', amount: 0.62 },
            { name: 'yeast', amount: 0.02 },
            { name: 'salt', amount: 0.02 }
          ]
        }

        post "/api/v1/users/#{user.id}/recipes",
          params: { token: token, recipe: list }

        expect(response).to be_successful

        new_recipe = JSON.parse(response.body, symbolize_names: true)

        recipe_date = user.recipes.last.created_at

        expect(response.status).to eq(201)
        expect(new_recipe[:id]).to eq(user.recipes.last.id)
        expect(new_recipe[:name]).to eq(user.recipes.last.name)
        expect(Recipe.exists?(name: 'baguette')).to be(true)
        expect(Ingredient.where(name: ingredient_names).pluck(:name)).to include(*ingredient_names)
        expect(RecipeIngredient.where(recipe_id: new_recipe[:id]).pluck(:amount)).to include(*ingredient_amounts)
        expect(new_recipe[:created_at]).to eq(recipe_date.strftime("Created on %d %^b '%y at %H:%M"))
      end
    end

    it 'cannot create a recipe with same name as one that already exists' do
      VCR.use_cassette('dupe_recipes') do
        user.recipes.clear
        user.recipes << create(:recipe, name: 'baguette')
        list = {
          name: 'baguette',
          ingredients: {
            flour: { amount: 1.00 },
            water: { amount: 0.62 },
            yeast: { amount: 0.02 },
            salt: { amount: 0.02 }
          }
        }

        post "/api/v1/users/#{user.id}/recipes",
          params: { token: token, recipe: list }

        expect(response).not_to be_successful

        result = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(404)
        expect(result[:message]).to eq('You already have a recipe with that name')
      end
    end

    it 'can assign a tag to a recipe' do
      VCR.use_cassette('tags') do
        list = {
          name: 'baguette',
          ingredients: [
            { name: 'flour', amount: 1.00 },
            { name: 'water', amount: 0.62 },
            { name: 'yeast', amount: 0.02 },
            { name: 'salt', amount: 0.02 }
          ]
        }
        tags = %w[Lean Baguette French\ Bread]

        post "/api/v1/users/#{user.id}/recipes",
          params: { token: token, recipe: list, tags: tags }

        expect(response).to be_successful

        recipe = JSON.parse(response.body, symbolize_names: true)

        recipe[:tags].each do |tag|
          expect(tags).to include(tag[:name])
        end
      end
    end

    it 'user can delete recipe' do
      VCR.use_cassette('formatting') do
        recipe = user.recipes[0]
        flour  = create(:ingredient, name: 'Flour')
        recipe.recipe_ingredients << create(:recipe_ingredient, ingredient_id: flour.id)

        delete "/api/v1/users/#{user.id}/recipes/#{recipe.id}",
          params: { token: token }

        expect(response).to be_successful

        deleted = JSON.parse(response.body, symbolize_names: true)

        expect(deleted[:status]).to eq(204)
        expect(deleted[:message]).to eq("Successfully deleted #{recipe.name}")
        expect(Recipe.all).not_to include(recipe.id)
      end
    end

    it 'returns the family of the recipe' do
      VCR.use_cassette('family') do
        list = {
          name: 'baguette',
          ingredients: [
            { name: 'flour', amount: 1.00 },
            { name: 'water', amount: 0.62 },
            { name: 'yeast', amount: 0.02 },
            { name: 'salt', amount: 0.02 }
          ]
        }
        post "/api/v1/users/#{user.id}/recipes",
          params: { recipe: list, token: token }

        new_recipe = JSON.parse(response.body, symbolize_names: true)

        get "/api/v1/users/#{user.id}/recipes/#{new_recipe[:id]}",
          params: { token: token }

        expect(response).to be_successful

        return_recipe = JSON.parse(response.body, symbolize_names: true)

        expect(return_recipe[:family]).to eq('Lean')
      end
    end

    it 'returns list of recipes that align with requested family' do
      VCR.use_cassette('formatting') do
        recipe = user.recipes[0]

        get "/api/v1/families/#{recipe.family.name}", params: { token: token }

        expect(response).to be_successful

        family = JSON.parse(response.body, symbolize_names: true)

        expect(family[:name]).to eq(recipe.family.name)
        expect(family[:recipes].empty?).not_to be true
      end
    end
  end
end
